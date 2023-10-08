//
//  ScreenUtil.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import UIKit

struct ScreenUtil {
    private init() { }
    
    static let shared = ScreenUtil()
    
    let safeAreaTopMargin: CGFloat = {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0.0
        }
        
        return window.safeAreaLayoutGuide.layoutFrame.minY
    }()
    
    let safeAreaBottomMargin: CGFloat = {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0.0
        }
        
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        return window.frame.maxY - safeFrame.maxY
    }()
    
}
