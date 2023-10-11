//
//  ViewController.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import UIKit
import SnapKit
import Then
import Combine
import CombineCocoa

class SearchViewController: BaseViewController {
    
    var cancelBag = Set<AnyCancellable>()
    
    var searchAppProtocol: SearchViewModel
    
    init(_ searchAppProtocol: SearchViewModel) {
        self.searchAppProtocol = searchAppProtocol
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
    
    lazy var deleteIcon = UIImageView().then {
        $0.image = UIImage(systemName: "xmark.circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Colors.gray.rawValue.hexStringToUIColor
        
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextDeletePressed)))
        //        $0.accessibilityIdentifier = SVIdentifiers.deleteIcon.rawValue
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
        //        $0.accessibilityIdentifier = SVIdentifiers.searchField.rawValue
    }
    
    lazy var appInfoCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var appInfoCollectionView = AppInfoCollectionView(frame: .zero, collectionViewLayout: appInfoCollectionViewFlowLayout, searchAppProtocol: searchAppProtocol).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.textPublisher.sink(receiveValue: { [weak self] text in
            self?.deleteIcon.isHidden = (text?.count == 0)
        }).store(in: &cancelBag)
        
        searchAppProtocol.apps.sink(receiveValue: { [weak self] apps in
            self?.appInfoCollectionView.reloadData()
        }).store(in: &cancelBag)
    }
    
    override func addSubviews() {
        view.addSubview(searchField)
        view.addSubview(appInfoCollectionView)
    }
    
    override func addConstraints() {
        searchField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtil.shared.safeAreaTopMargin)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        appInfoCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-ScreenUtil.shared.safeAreaBottomMargin)
        }
    }
    
    func searchApps(_ name: String) {
        searchAppProtocol.searchApps(name).sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] value in
            guard let self else { return }
            
            var existingApps = searchAppProtocol.apps.value
            existingApps.append(contentsOf: value.results)
            
            self.searchAppProtocol.apps.value = existingApps
            self.searchAppProtocol.isFetching.value = false
            self.searchAppProtocol.pageIndex += 1
            
            if value.results.count < 10 {
                self.searchAppProtocol.isEndReached = true
            }
        }).store(in: &cancelBag)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        deleteIcon.isHidden = text.count == 0
    }
    
    @objc func onTextDeletePressed() {
        searchField.text = ""
        deleteIcon.isHidden = true
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text,
           text.count > 0 {
            searchAppProtocol.initialize()
            searchAppProtocol.isFetching.value = true
            searchAppProtocol.word = text
            searchApps(text)
        }
        
        return true
    }
}

extension SearchViewController: AppInfoCollectionViewDelegate {
    func appInfoCollectionView(_ collectionView: AppInfoCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(detailViewModel: DetailViewModel(appInfo: searchAppProtocol.apps.value[indexPath.row]))
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
