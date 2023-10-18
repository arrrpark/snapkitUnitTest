//
//  AppInfoCell.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 09/10/2023.
//

import UIKit
import SnapKit
import Then
import Cosmos

class AppInfoCell: UICollectionViewCell {
    
    static let appGuideWidth = ((UIScreen.main.bounds.width - 40) / 3) - 10
    
    var appIconURL: URL?
    var appGuideURL1: URL?
    var appGuideURL2: URL?
    var appGuideURL3: URL?
    
    lazy var appInfoContainerView = UIView()
    
    lazy var appIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.lightGray.rawValue.hexStringToUIColor.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 1
        $0.textColor = .black
    }
    
    lazy var genresLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = Colors.deepGray.rawValue.hexStringToUIColor
    }
    
    lazy var ratingView = CosmosView().then {
        $0.settings.updateOnTouch = false
        $0.settings.starMargin = 2
        $0.settings.starSize = 13
        $0.settings.filledColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.settings.emptyBorderColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.settings.filledBorderColor = Colors.deepGray.rawValue.hexStringToUIColor
        $0.settings.fillMode = .precise
    }
    
    lazy var ratingLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = Colors.deepGray.rawValue.hexStringToUIColor
    }
    
    lazy var appGuideImageView1 = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.lightGray.rawValue.hexStringToUIColor.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    lazy var appGuideImageView2 = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.lightGray.rawValue.hexStringToUIColor.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    lazy var appGuideImageView3 = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.lightGray.rawValue.hexStringToUIColor.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    lazy var appGuideImagesContainer = UIView().then {
        $0.addSubview(appGuideImageView1)
        $0.addSubview(appGuideImageView2)
        $0.addSubview(appGuideImageView3)
        
        appGuideImageView1.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(AppInfoCell.appGuideWidth)
        }
        
        appGuideImageView2.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(AppInfoCell.appGuideWidth)
            $0.centerX.equalToSuperview()
        }
        
        appGuideImageView3.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(AppInfoCell.appGuideWidth)
        }
    }
    
    lazy var downloadButton = UIButton().then {
        $0.setTitle("Download", for: .normal)
        $0.setTitleColor(Colors.basicTint.rawValue.hexStringToUIColor, for: .normal)
        $0.backgroundColor = Colors.backgroundGray.rawValue.hexStringToUIColor
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCellWithItem(_ info: AppInfo) {
        titleLabel.text = info.trackCensoredName
        
        appIconURL = URL(string: info.artworkUrl512)
        appIconImageView.setImageWithURL(appIconURL)
        genresLabel.text = info.genres.genresString
        ratingView.rating = info.averageUserRating
        
        if info.screenshotUrls.count > 0 {
            appGuideURL1 = URL(string: info.screenshotUrls[0])
            appGuideImageView1.setImageWithURL(appGuideURL1)
        } else {
            appGuideImageView1.isHidden = true
        }
        
        if info.screenshotUrls.count > 1 {
            appGuideURL2 = URL(string: info.screenshotUrls[1])
            appGuideImageView2.setImageWithURL(appGuideURL2)
        } else {
            appGuideImageView2.isHidden = true
        }
        
        if info.screenshotUrls.count > 2 {
            appGuideURL3 = URL(string: info.screenshotUrls[2])
            appGuideImageView3.setImageWithURL(appGuideURL3)
        } else {
            appGuideImageView3.isHidden = true
        }
        
        ratingLabel.text = info.userRatingCount.ratingString
    }
    
    private func setupViews() {
        addSubview(appInfoContainerView)
        appInfoContainerView.addSubview(appIconImageView)
        appInfoContainerView.addSubview(titleLabel)
        appInfoContainerView.addSubview(genresLabel)
        appInfoContainerView.addSubview(ratingView)
        appInfoContainerView.addSubview(ratingLabel)
        appInfoContainerView.addSubview(downloadButton)
        
        addSubview(appGuideImagesContainer)
    }
    
    private func setupConstraints() {
        appInfoContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        appIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-5)
            $0.top.equalTo(appIconImageView)
        }
        
        genresLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.centerY.equalToSuperview()
        }
        
        ratingView.snp.makeConstraints {
            $0.bottom.equalTo(appInfoContainerView).offset(-5)
            $0.leading.equalTo(genresLabel)
            $0.width.equalTo(70)
            $0.height.equalTo(20)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.leading.equalTo(ratingView.snp.trailing).offset(10)
            $0.top.equalTo(ratingView)
        }
        
        downloadButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(80)
            $0.height.equalTo(25)
            $0.centerY.equalToSuperview()
        }
        
        appGuideImagesContainer.snp.makeConstraints {
            $0.top.equalTo(appInfoContainerView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(AppInfoCell.appGuideWidth / 4 * 7)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        appGuideImageView1.isHidden = false
        appGuideImageView1.image = nil
        
        appGuideImageView2.isHidden = false
        appGuideImageView2.image = nil
        
        appGuideImageView3.isHidden = false
        appGuideImageView3.image = nil
    }
}

