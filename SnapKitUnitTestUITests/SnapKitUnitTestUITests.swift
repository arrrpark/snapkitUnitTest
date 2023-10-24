//
//  SnapKitUnitTestUITests.swift
//  SnapKitUnitTestUITests
//
//  Created by Arrr Park on 08/10/2023.
//

import XCTest

final class SnapKitUnitTestUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testAppInfoCollectionViewPaging() {
        let textField = app.textFields[SVIdentifiders.searchField.rawValue]
        textField.tap()
        textField.typeText("Message")
        app.buttons["Done"].tap()
        
        let expectation = expectation(description: "appInfoCollectionView view paging test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [unowned self] in
            let appInfoCollectionView = self.app.collectionViews[SVIdentifiders.appInfoCollectionView.rawValue]

            while !appInfoCollectionView.staticTexts["Avakin Life: 3D Avatar Creator"].exists {
                app.swipeUp()
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 20)
    }
    
    func testRecentWordsCollectionView() {
        let collectionView = app.collectionViews[SVIdentifiders.recentWordCollectionView.rawValue]
        
        let textField = app.textFields[SVIdentifiders.searchField.rawValue]
        textField.tap()
        textField.typeText("M")
        XCTAssertTrue(collectionView.cells.count == 10)
        
        textField.typeText("i")
        XCTAssertTrue(collectionView.cells.count == 2)
        
        textField.typeText("c")
        XCTAssertTrue(collectionView.cells.count == 1)
        
        app.keys["delete"].tap()
        collectionView.cells.element(boundBy: 1).tap()
    
        XCTAssertFalse(collectionView.exists)
    }
}
