//
//  ViewController.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let searchViewModel: SearchViewModel
    
    init(_ searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchIcon = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Colors.gray.rawValue.hexStringToUIColor
    }
    
    lazy var deleteIcon = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = Colors.gray.rawValue.hexStringToUIColor
        
        $0.rx.tap.bind { [weak self] in
            self?.onTextDeletePressed()
        }.disposed(by: disposeBag)
    }
    
    lazy var searchField = UITextField().then  {
        $0.textColor = .black
        $0.backgroundColor = Colors.backgroundGray.rawValue.hexStringToUIColor
        $0.addSubview(searchIcon)
        $0.addSubview(deleteIcon)
        $0.placeholder = "Games, Apps, Stories and More"
        
        searchIcon.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leadingMargin.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
        }
        
        deleteIcon.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailingMargin.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
        }
        
        $0.setLeftPaddingPoints(30)
        $0.setRightPaddingPoints(30)
        $0.returnKeyType = .done
        $0.delegate = self
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    lazy var recentWordsFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var recentWordCollectionView = RecentWordCollectionView(frame: .zero, collectionViewLayout: recentWordsFlowLayout, searchViewModel: searchViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    lazy var appInfoCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var appInfoCollectionView = AppInfoCollectionView(frame: .zero, collectionViewLayout: appInfoCollectionViewFlowLayout, searchAppProtocol: searchViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.rx.value.asDriver().drive(onNext: { [weak self] text in
            guard let self, let text else { return }
            
            self.searchViewModel.isSearchFieldCharacterExists.accept(text.count > 0)
            self.searchViewModel.searchedWords.accept(RecentWordDAO.shared.getWords(text))
        }).disposed(by: disposeBag)
        
        searchField.rx.controlEvent(.editingDidBegin).subscribe(onNext:{[weak self] in
            self?.searchViewModel.isSearchFieldFocused.accept(true)
        }).disposed(by: disposeBag)
        
        searchField.rx.controlEvent(.editingDidEnd).subscribe(onNext:{[weak self] in
            self?.searchViewModel.isSearchFieldFocused.accept(false)
        }).disposed(by: disposeBag)
        
        searchViewModel.apps.subscribe { [weak self] _ in
            self?.appInfoCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        Observable.combineLatest(searchViewModel.isSearchFieldFocused, searchViewModel.isSearchFieldCharacterExists, searchViewModel.apps).subscribe { [weak self] isFocused, isCharacterExists, apps in
            guard let self else { return }
            
            self.deleteIcon.isHidden = !(isFocused && isCharacterExists)
            self.recentWordCollectionView.isHidden = !(isFocused && isCharacterExists)
            self.appInfoCollectionView.isHidden = !self.recentWordCollectionView.isHidden
        }.disposed(by: disposeBag)
        
        searchViewModel.searchedWords.subscribe { [weak self] _ in
            self?.recentWordCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func addSubviews() {
        view.addSubview(searchField)
        view.addSubview(recentWordCollectionView)
        view.addSubview(appInfoCollectionView)
    }
    
    override func addConstraints() {
        searchField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtil.shared.safeAreaTopMargin)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        recentWordCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-ScreenUtil.shared.safeAreaBottomMargin)
        }
        
        appInfoCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-ScreenUtil.shared.safeAreaBottomMargin)
        }
    }
    
    func searchApps(_ name: String) {
        guard !searchViewModel.isFetching.value else { return }
        
        searchViewModel.isFetching.accept(true)
        searchViewModel.searchApps(name).subscribe { [weak self] value in
            guard let self else { return }
            
            var existingApps = self.searchViewModel.apps.value
            existingApps.append(contentsOf: value.results)
            
            self.searchViewModel.apps.accept(existingApps)
            self.searchViewModel.isFetching.accept(false)
            self.searchViewModel.pageIndex += 1
            
            if value.results.count < 10 {
                self.searchViewModel.isEndReached = true
            }
            
            if value.results.count > 0 {
                RecentWordDAO.shared.saveOrUpdate(name)
            }
            
            print("count : \(self.searchViewModel.apps.value.count)")
        }.disposed(by: disposeBag)
        
    }
    
    func saveImage(_ image: UIImage, name: String) -> URL? {
        guard let data = image.pngData(),
              let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        
        do {
            try data.write(to: directory.appendingPathComponent(name))
            return directory.appendingPathComponent(name)
        } catch {
            return nil
        }
    }
    
    func onTextDeletePressed() {
        searchField.text = ""
        searchField.sendActions(for: .editingChanged)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text,
           text.count > 0 {
            searchViewModel.initialize()
            searchViewModel.word = text
            searchApps(text)
        }
        
        return true
    }
}

extension SearchViewController: AppInfoCollectionViewDelegate {
    func appInfoCollectionView(_ collectionView: AppInfoCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(detailViewModel: DetailViewModel(appInfo: searchViewModel.apps.value[indexPath.row]))
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func fetchMoreApps() {
        searchApps(searchViewModel.word)
    }
}

extension SearchViewController: RecentWordCollectionViewDelegate {
    func recentWordCollectionView(_ collectionView: RecentWordCollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let word = searchViewModel.searchedWords.value[indexPath.row].word else { return }
        
        view.endEditing(true)
        searchField.text = word
        RecentWordDAO.shared.saveOrUpdate(word)
        searchApps(word)
    }
}
