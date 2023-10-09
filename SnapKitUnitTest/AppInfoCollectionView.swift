//
//  AppInfoCollectionView.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 09/10/2023.
//

import UIKit
import Kingfisher

protocol AppInfoCollectionViewDelegate: AnyObject {
    func newBookCollectionView(_ collectionView: AppInfoCollectionView, didSelectItemAt indexPath: IndexPath)
    func fetchMoreApps()
}

class AppInfoCollectionView: UICollectionView {
    weak var viewDelegate: AppInfoCollectionViewDelegate?
    
    let searchAppProtocol: SearchAppProtocol
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, searchAppProtocol: SearchAppProtocol) {
        self.searchAppProtocol = searchAppProtocol
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(AppInfoCell.self, forCellWithReuseIdentifier: String(describing: AppInfoCell.self))
        
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppInfoCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.newBookCollectionView(self, didSelectItemAt: indexPath)
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard indexPath.row == searchAppProtocol.apps.value.count - 1,
//              !searchAppProtocol.isFetching.value,
//              !searchAppProtocol.isEndReached else {
//            return
//        }
//        
//        viewDelegate?.fetchMoreApps()
//    }
}

extension AppInfoCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchAppProtocol.apps.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: AppInfoCell.self), for: indexPath) as? AppInfoCell else {
            return UICollectionViewCell()
        }

        let data = searchAppProtocol.apps.value[indexPath.row]
        
        cell.titleLabel.text = data.trackCensoredName
        
        let appIconURL = URL(string: data.artworkUrl512)
        cell.appIconImageView.kf.setImage(with: appIconURL)
        cell.genresLabel.text = data.genres.genresString
        cell.ratingView.rating = data.averageUserRating
        
        if data.screenshotUrls.count > 0 {
            cell.appGuideImage1.kf.setImage(with: URL(string: data.screenshotUrls[0]))
        } else {
            cell.appGuideImage1.isHidden = true
        }
        
        if data.screenshotUrls.count > 1 {
            cell.appGuideImage2.kf.setImage(with: URL(string: data.screenshotUrls[1]))
        } else {
            cell.appGuideImage2.isHidden = true
        }
        
        if data.screenshotUrls.count > 2 {
            cell.appGuideImage3.kf.setImage(with: URL(string: data.screenshotUrls[2]))
        } else {
            cell.appGuideImage3.isHidden = true
        }
        
        cell.ratingLabel.text = data.userRatingCount.ratingString
        return cell
    }
}

extension AppInfoCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: AppInfoCell.appGuideWidth / 4 * 7 + 120)
    }
}

