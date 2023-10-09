//
//  String+Extension.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import UIKit

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

extension Array where Element == String {
    var genresString: String {
        let genresString = NSMutableString()
        self.forEach {
            genresString.append($0)
            genresString.append(", ")
        }
        genresString.deleteCharacters(in: NSRange(location: genresString.length - 2, length: 2))
        return genresString as String
    }
}
