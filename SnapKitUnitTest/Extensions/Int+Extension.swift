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
            if self > 9999 {
                let rating = NSMutableString(string: "\(round((Double(self) / 10000.0) * 10) / 10)")
                
                if rating.hasSuffix(".0") {
                    rating.deleteCharacters(in: NSRange(location: rating.length - 2, length: 2))
                }
                
                return "\(rating) 만"
            } else {
                return String(self)
            }
        }
    }
}
