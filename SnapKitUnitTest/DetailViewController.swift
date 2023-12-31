//
//  DetailViewController.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 10/10/2023.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import Cosmos
import RxSwift

class DetailViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let detailViewModel: DetailViewModel
    
    lazy var headerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var backButtonConfig: UIButton.Configuration = {
        var config = UIButton.Configuration.plain()
        config.title = "Search"
        config.image = UIImage(systemName: "chevron.left")
        config.imagePadding = 5
        return config
    }()
    
    lazy var backButton = UIButton(configuration: backButtonConfig).then {
        $0.setTitleColor(Colors.basicTint.rawValue.hexStringToUIColor, for: .normal)
        $0.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    lazy var containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy var iconImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = Colors.lightGray.rawValue.hexStringToUIColor.cgColor
        $0.layer.borderWidth = 1
        
        let appIconURL = URL(string: detailViewModel.appInfo.artworkUrl512)
        $0.setImageWithURL(appIconURL)
    }
    
    lazy var appTitle = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = detailViewModel.appInfo.trackCensoredName
        $0.numberOfLines = 1
    }
    
    lazy var genresLabel = UILabel().then {
        $0.textColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = detailViewModel.appInfo.genres.genresString
    }
    
    lazy var downloadButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Download", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        $0.backgroundColor = Colors.basicTint.rawValue.hexStringToUIColor
        $0.layer.cornerRadius = 10
    }
    
    lazy var infoContainer = UIView()
    
    lazy var ratingLabel = UILabel().then {
        $0.textColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = "\(round(detailViewModel.appInfo.averageUserRating * 10) / 10)"
    }
    
    lazy var ratingView = CosmosView().then {
        $0.settings.updateOnTouch = false
        $0.settings.starSize = 18
        $0.settings.filledColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.settings.emptyBorderColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.settings.filledBorderColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.settings.fillMode = .precise
        $0.rating = detailViewModel.appInfo.averageUserRating
    }
    
    lazy var ratingCountLabel = UILabel().then {
        $0.textColor = Colors.gray.rawValue.hexStringToUIColor
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "\(detailViewModel.appInfo.userRatingCount.ratingString) RATINGS"
    }
    
    lazy var ageGuideLabel = UILabel().then {
        $0.textColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = detailViewModel.appInfo.contentAdvisoryRating
    }
    
    lazy var ageLabel = UILabel().then {
        $0.textColor = Colors.gray.rawValue.hexStringToUIColor
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "age"
    }
    
    lazy var detailAppImageFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var detailAppImageCollectionView = DetailAppImageCollectionView(frame: .zero, collectionViewLayout: detailAppImageFlowLayout, detailViewModel: detailViewModel).then {
        $0.backgroundColor = .clear
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.text = detailViewModel.appInfo.description
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 3
        $0.lineBreakMode = .byTruncatingTail
    }
    
    lazy var viewMoreButton = UIButton().then {
        $0.setTitle("more", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.setTitleColor(Colors.basicTint.rawValue.hexStringToUIColor, for: .normal)
        $0.rx.tap.bind { [weak self] in
            self?.onViewMorePressed()
        }.disposed(by: disposeBag)
    }

    init(detailViewModel: DetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addSubviews() {
        super.addSubviews()

        view.addSubview(containerView)
        
        view.addSubview(headerView)
        headerView.addSubview(backButton)

        containerView.addSubview(iconImageView)
        containerView.addSubview(appTitle)
        containerView.addSubview(genresLabel)
        containerView.addSubview(downloadButton)

        containerView.addSubview(infoContainer)
        infoContainer.addSubview(ratingLabel)
        infoContainer.addSubview(ratingView)
        infoContainer.addSubview(ratingCountLabel)
        infoContainer.addSubview(ageGuideLabel)
        infoContainer.addSubview(ageLabel)

        containerView.addSubview(detailAppImageCollectionView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(viewMoreButton)
    }

    override func addConstraints() {
        super.addConstraints()

        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtil.shared.safeAreaTopMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtil.shared.safeAreaTopMargin)
            $0.leading.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.bottom.equalToSuperview().offset(-ScreenUtil.shared.safeAreaBottomMargin)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(20)
        }

        appTitle.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.top)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(15)
            $0.width.equalTo(UIScreen.main.bounds.width - 130)
        }

        genresLabel.snp.makeConstraints {
            $0.top.equalTo(appTitle.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(appTitle)
        }

        downloadButton.snp.makeConstraints {
            $0.bottom.equalTo(iconImageView)
            $0.leading.equalTo(genresLabel)
            $0.width.equalTo(85)
            $0.height.equalTo(25)
        }

        infoContainer.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.height.equalTo(40)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(ratingView).offset(-1)
        }

        ratingView.snp.makeConstraints {
            $0.leading.equalTo(ratingLabel.snp.trailing).offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(20)
        }

        ratingCountLabel.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(5)
            $0.leading.equalTo(ratingLabel)
        }

        ageGuideLabel.snp.makeConstraints {
            $0.centerY.equalTo(ratingView).offset(-1)
            $0.trailing.equalToSuperview()
        }

        ageLabel.snp.makeConstraints {
            $0.top.equalTo(ageGuideLabel.snp.bottom).offset(5)
            $0.centerX.equalTo(ageGuideLabel)
        }

        detailAppImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoContainer.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.height.equalTo(DetailAppImageCell.appGuideWidth / 4 * 7 + 10)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(detailAppImageCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.bottom.equalToSuperview()
        }

        viewMoreButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(descriptionLabel)
        }
    }
    
    func onViewMorePressed() {
        descriptionLabel.numberOfLines = 0
        viewMoreButton.isHidden = true
    }
}

