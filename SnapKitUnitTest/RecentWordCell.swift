//
//  RecentWordsCell.swift
//  AppSearch
//
//  Created by Arrr Park on 20/09/2023.
//

import UIKit
import SnapKit
import Then

class RecentWordCell: UICollectionViewCell {
    
    lazy var imageIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = Colors.gray.rawValue.hexStringToUIColor
    }
    
    lazy var wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .black
    }
    
    lazy var border = UIView().then {
        $0.backgroundColor = Colors.backgroundGray.rawValue.hexStringToUIColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageIcon)
        addSubview(wordLabel)
        addSubview(border)
    }
    
    private func setupConstraints() {
        imageIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(15)
            $0.centerY.equalToSuperview()
        }
        
        wordLabel.snp.makeConstraints {
            $0.leading.equalTo(imageIcon.snp.trailing).offset(5)
            $0.centerY.equalTo(imageIcon)
        }
        
        border.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
    }
}
