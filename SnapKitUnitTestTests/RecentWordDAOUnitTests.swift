//
//  CoreDataUnitTests.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 23/10/2023.
//

import XCTest
import CoreData
@testable import SnapKitUnitTest

class RecentWordDAOUnitTests: XCTestCase {
    var recentWordDAO: RecentWordDAOForTest!
    
    override func setUp() {
        super.setUp()
        recentWordDAO = RecentWordDAOForTest.sharedForTest
        recentWordDAO.deleteWords()
    }
    
    override func tearDown() {
        super.tearDown()
        recentWordDAO.deleteWords()
        recentWordDAO = nil
    }
    
    func testInsertAndUpdateWord() {
        recentWordDAO.saveOrUpdateWord("Word")
        
        var words = recentWordDAO.getWords()
        XCTAssertTrue(words.count == 1)
        XCTAssertTrue(words[0].word == "Word")
        
        recentWordDAO.saveOrUpdateWord("iOS")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 2)
        XCTAssertTrue(words[0].word == "iOS")
        XCTAssertTrue(words[1].word == "Word")
    }
    
    func testInsertAndUpdateWordUntil100Words() {
        recentWordDAO.insert98Words()
        
        var words = recentWordDAO.getWords()
        XCTAssertTrue(words.count == 98)
        
        recentWordDAO.saveOrUpdateWord("Android")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 99)
        XCTAssertTrue(words[0].word == "Android")
        
        recentWordDAO.saveOrUpdateWord("iOS")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 100)
        XCTAssertTrue(words[0].word == "iOS")
        
        recentWordDAO.saveOrUpdateWord("React")
        words = recentWordDAO.getWords()
        
        XCTAssertTrue(words.count == 100)
        XCTAssertTrue(words[0].word == "React")
        XCTAssertTrue(words[1].word == "iOS")
        XCTAssertTrue(words[2].word == "Android")
    }
    
    func testFilteredWords() {
        recentWordDAO.insert98Words()
        var words = recentWordDAO.getFilteredWords("kk", limit: 100)
        XCTAssertTrue(words.count == 50)
        
        words = recentWordDAO.getFilteredWords("kkk", limit: 100)
        XCTAssertTrue(words.count == 49)
        
        words = recentWordDAO.getFilteredWords("kkk")
        XCTAssertTrue(words.count == 10)
        
        words = recentWordDAO.getFilteredWords("m", limit: 100)
        XCTAssertTrue(words.count == 48)
        
        words = recentWordDAO.getFilteredWords("ma", limit: 100)
        XCTAssertTrue(words.count == 48)
        
        words = recentWordDAO.getFilteredWords("i")
        XCTAssertTrue(words.count == 0)
        
        recentWordDAO.saveOrUpdateWord("iOS")
        words = recentWordDAO.getFilteredWords("i")
        XCTAssertTrue(words.count == 1)
    }
}
