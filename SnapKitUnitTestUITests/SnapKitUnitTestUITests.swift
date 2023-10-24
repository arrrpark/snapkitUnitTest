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
    
    func testDeleteIconAppearsWhenTextExists() {
        let deleteIcon = app.buttons[SVIdentifiders.deleteIcon.rawValue]
        
        print(deleteIcon.exists)
        print(deleteIcon.isHittable)
        print(deleteIcon.frame.size.width)
        print(deleteIcon.frame.size.height)
        deleteIcon.tap()
        
//        let textField = app.textFields[SVIdentifiders.searchField.rawValue]
//        textField.tap()
//        textField.typeText("Hello")
        
        //        app.textFields[SVIdentifiders.searchField.rawValue].typeText("Hello")
//        app.textFields[SVIdentifiders.searchField.rawValue].typeText("Hello")
    }
}
