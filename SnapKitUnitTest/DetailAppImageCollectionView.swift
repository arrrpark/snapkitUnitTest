//
//  DetailAppImageCollectionView.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 10/10/2023.
//

import UIKit
import Kingfisher

protocol DetailAppImageCollectionViewDelegate: AnyObject {
    func detailImageCollectionView(_ collectionView: DetailAppImageCollectionView, didSelectItemAt indexPath: IndexPath)
}

class DetailAppImageCollectionView: UICollectionView {
    weak var viewDelegate: DetailAppImageCollectionViewDelegate?
    
    let detailViewModel: DetailViewModel
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, detailViewModel: DetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(DetailAppImageCell.self, forCellWithReuseIdentifier: String(describing: DetailAppImageCell.self))
        
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailAppImageCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.detailImageCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension DetailAppImageCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailViewModel.appInfo.screenshotUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: DetailAppImageCell.self), for: indexPath) as? DetailAppImageCell else {
            return UICollectionViewCell()
        }

        let imageUrl = detailViewModel.appInfo.screenshotUrls[indexPath.row]
        
        let appGuideURL = URL(string: imageUrl)
        cell.appGuideImage.kf.setImage(with: appGuideURL)
        return cell
    }
}

extension DetailAppImageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DetailAppImageCell.appGuideWidth, height: DetailAppImageCell.appGuideWidth / 4 * 7)
    }
}

extension DetailAppImageCollectionView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth = DetailAppImageCell.appGuideWidth
        let cellPadding: CGFloat = 10

        var page = Int((scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1)

        if velocity.x > 0 {
            page += 1
        }

        if velocity.x < 0 {
            page -= 1
        }

        let currentPage = max(page, 0)

        let newOffset = CGFloat(currentPage) * (cellWidth + cellPadding)
        targetContentOffset.pointee.x = newOffset
    }
}


