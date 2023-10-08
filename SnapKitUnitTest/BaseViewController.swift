//
//  BaseViewController.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() { }
    
    func addConstraints() { }
}
