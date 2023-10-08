//
//  AppInfo.swift
//  SnapKitUnitTest
//
//  Created by Arrr Park on 08/10/2023.
//

import Foundation

struct AppInfo: Codable {
    var screenshotUrls: [String]
    var description: String
    var trackCensoredName: String
    var averageUserRating: Double
    var genres: [String]
    var artworkUrl512: String
    var userRatingCount: Int
    var contentAdvisoryRating: String
}
