//
//  String+Extension.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import UIKit

enum Colors: String {
    case backgroundGray = "ECECEC"
    case lightGray = "D4D4D4"
    case gray = "B2B2B2"
    case deepGray = "8C8C8C"
    case basicTint = "0078FF"
}

extension String {
    var hexStringToUIColor: UIColor {
        get {
            var cString = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }

            if ((cString.count) != 6) {
                return UIColor.gray
            }

            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
}
