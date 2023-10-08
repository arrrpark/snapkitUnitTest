//
//  NavigationController.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import UIKit
import SnapKit
import Then

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
    
}
