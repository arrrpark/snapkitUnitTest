//
//  Int+Extension.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 09/10/2023.
//

import Foundation

extension Int {
    var ratingString: String {
        get {
            var count = 0
            var dividedSelf = self
            
            while dividedSelf >= 1000 || count != 2 {
                if dividedSelf / 1000 == 0 {
                    break
                }
                count += 1
                dividedSelf /= 1000
            }
            
            if count == 1 {
                return "\(dividedSelf)K"
            }
            
            if count == 2 {
                return "\(dividedSelf)M"
            }
            
            return String(dividedSelf)
        }
    }
}
