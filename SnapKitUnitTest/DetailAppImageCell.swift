//
//  DetailAppImageCell.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 10/10/2023.
//

import UIKit
import SnapKit
import Then
import Cosmos

class DetailAppImageCell: UICollectionViewCell {
    
    static let appGuideWidth = UIScreen.main.bounds.width * 0.6
    
    lazy var appGuideImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.lightGray.rawValue.hexStringToUIColor.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
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
    
    private func setupViews() {
        addSubview(appGuideImage)
    }
    
    private func setupConstraints() {
        appGuideImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

