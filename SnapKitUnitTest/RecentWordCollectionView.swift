//
//  RecentWordCollectionView.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 18/10/2023.
//

import UIKit

protocol RecentWordCollectionViewDelegate: AnyObject {
    func recentWordCollectionView(_ collectionView: RecentWordCollectionView, didSelectItemAt indexPath: IndexPath)
}

class RecentWordCollectionView: UICollectionView {
    weak var viewDelegate: RecentWordCollectionViewDelegate?
    
    let searchViewModel: SearchViewModel
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(RecentWordCell.self, forCellWithReuseIdentifier: String(describing: RecentWordCell.self))
        
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecentWordCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.recentWordCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension RecentWordCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModel.searchedWords.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: RecentWordCell.self), for: indexPath) as? RecentWordCell else {
            return UICollectionViewCell()
        }

        let data = searchViewModel.searchedWords.value[indexPath.row]
        cell.wordLabel.text = data.word
        return cell
    }
}

extension RecentWordCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}

