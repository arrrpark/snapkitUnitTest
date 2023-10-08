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

class SearchViewController: BaseViewController {
    
    lazy var searchIcon = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Colors.gray.rawValue.hexStringToUIColor
    }
    
    lazy var deleteIcon = UIImageView().then {
        $0.image = UIImage(systemName: "xmark.circle.fill")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Colors.gray.rawValue.hexStringToUIColor
        
//        $0.isUserInteractionEnabled = true
//        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextDeletePressed)))
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
//        $0.accessibilityIdentifier = SVIdentifiers.searchField.rawValue
//        $0.delegate = self
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
//        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubviews() {
        view.addSubview(searchField)
    }
    
    override func addConstraints() {
        searchField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtil.shared.safeAreaTopMargin)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
    }
}

