//
//  AppInfoCollectionView.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 09/10/2023.
//

import UIKit
import Kingfisher

protocol AppInfoCollectionViewDelegate: AnyObject {
    func appInfoCollectionView(_ collectionView: AppInfoCollectionView, didSelectItemAt indexPath: IndexPath)
//    func fetchMoreApps()
}

class AppInfoCollectionView: UICollectionView {
    weak var viewDelegate: AppInfoCollectionViewDelegate?
    
    let searchAppProtocol: SearchViewModel
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, searchAppProtocol: SearchViewModel) {
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
        viewDelegate?.appInfoCollectionView(self, didSelectItemAt: indexPath)
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
        cell.configCellWithItem(data)
        return cell
    }
}

extension AppInfoCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: AppInfoCell.appGuideWidth / 4 * 7 + 120)
    }
}

