//
//  ExtensionTests.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 18/10/2023.
//

import XCTest
@testable import SnapKitUnitTest

class ExtensionTests: XCTestCase {
    func testGenresString() {
        var genres = ["finance", "business", "productivity"]
        XCTAssertEqual(genres.genresString, "finance, business, productivity")
        
        genres.remove(at: genres.count - 1)
        XCTAssertEqual(genres.genresString, "finance, business")
        
        genres.remove(at: genres.count - 1)
        XCTAssertEqual(genres.genresString, "finance")
    }
    
    func testRatingStringTest() {
        var num = 120000
        XCTAssertEqual(num.ratingString, "120K")
        num = 1000000
        XCTAssertEqual(num.ratingString, "1M")
        num = 250000000
        XCTAssertEqual(num.ratingString, "250M")
        num = 5000
        XCTAssertEqual(num.ratingString, "5K")
        num = 50
        XCTAssertEqual(num.ratingString, "50")
        num = 0
        XCTAssertEqual(num.ratingString, "0")
    }
}
