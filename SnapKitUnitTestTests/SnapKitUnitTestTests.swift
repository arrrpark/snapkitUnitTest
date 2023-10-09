//
//  SnapKitUnitTestTests.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 08/10/2023.
//

import XCTest
@testable import SnapKitUnitTest

final class SnapKitUnitTestTests: XCTestCase {
    var navigationController: NavigationController!
    var appSearchViewController: SearchViewController!
    
    override func setUp() {
        super.setUp()
        
        appSearchViewController = SearchViewController(SearchViewModel())
        navigationController = NavigationController(rootViewController: appSearchViewController)
    }
    
    override func tearDown() {
        super.tearDown()
        
        appSearchViewController = nil
        navigationController = nil
    }
    
    func testInitialStateProperlySet() {
        appSearchViewController.viewDidLoad()
        
        XCTAssertTrue(navigationController.navigationBar.isHidden)
        XCTAssertNotNil(appSearchViewController.navigationController)
        XCTAssertTrue(appSearchViewController.view.backgroundColor == .white)
    }
    
    func testSearchViewControllerProperlySet() {
        let searchIconImage = appSearchViewController.searchIcon.image
        let deleteIconImage = appSearchViewController.deleteIcon.image
        appSearchViewController.searchIcon.image = UIImage(named: "dummy")
        appSearchViewController.deleteIcon.image = UIImage(named: "dummy")
        
        appSearchViewController.viewDidLoad()
        appSearchViewController.view.layoutIfNeeded()
        
        let outerViewBounds = appSearchViewController.view.bounds
        let searchField = appSearchViewController.searchField
        let searchIcon = appSearchViewController.searchIcon
        let deleteIcon = appSearchViewController.deleteIcon
        
        var frame = searchField.frame
        XCTAssertEqual(frame.minX, 20)
        XCTAssertEqual(frame.minY, ScreenUtil.shared.safeAreaTopMargin)
        XCTAssertEqual(frame.width, UIScreen.main.bounds.width - 40)
        XCTAssertEqual(frame.height, 30)
        
        XCTAssertEqual(searchField.textColor, UIColor.black)
        XCTAssertEqual(searchField.backgroundColor, Colors.backgroundGray.rawValue.hexStringToUIColor)
        XCTAssertEqual(searchIcon.superview, searchField)
        XCTAssertEqual(deleteIcon.superview, searchField)
        XCTAssertEqual(searchField.placeholder, "Games, Apps, Stories and More")
        XCTAssertTrue(searchField.leftView?.bounds.width == 30)
        XCTAssertTrue(searchField.rightView?.bounds.width == 30)
        XCTAssertTrue(searchField.returnKeyType == .done)
        XCTAssertTrue(searchField.layer.cornerRadius == 5)
        XCTAssertTrue(searchField.clipsToBounds)
        
        frame = searchIcon.frame
        XCTAssertEqual(searchIconImage, UIImage(systemName: "magnifyingglass"))
        XCTAssertTrue(searchIcon.contentMode == .scaleAspectFit)
        XCTAssertEqual(searchIcon.tintColor, Colors.gray.rawValue.hexStringToUIColor)
        
        XCTAssertTrue(frame.minX == 5)
        XCTAssertTrue(TestUtil.shared.testViewEqualToSuperViewCenterY(searchIcon))
        XCTAssertTrue(searchIcon.frame.width == 20)
        XCTAssertTrue(searchIcon.frame.height == 20)
        
        frame = deleteIcon.frame
        XCTAssertEqual(deleteIconImage, UIImage(systemName: "xmark.circle.fill"))
        XCTAssertTrue(deleteIcon.contentMode == .scaleAspectFit)
        XCTAssertEqual(deleteIcon.tintColor, Colors.gray.rawValue.hexStringToUIColor)
        
        XCTAssertTrue(frame.minX == searchField.frame.width - 20 - 5)
        XCTAssertTrue(TestUtil.shared.testViewEqualToSuperViewCenterY(deleteIcon))
        XCTAssertTrue(deleteIcon.frame.width == 20)
        XCTAssertTrue(deleteIcon.frame.height == 20)
        
        let appInfoCollectionViewFlowLayout = appSearchViewController.appInfoCollectionViewFlowLayout
        XCTAssertTrue(appInfoCollectionViewFlowLayout.scrollDirection == .vertical)
        XCTAssertTrue(appInfoCollectionViewFlowLayout.minimumLineSpacing == 0)
        XCTAssertTrue(appInfoCollectionViewFlowLayout.minimumInteritemSpacing == 0)
        
        let appInfoCollectionView = appSearchViewController.appInfoCollectionView
        XCTAssertTrue(appInfoCollectionView.backgroundColor == .clear)
        print(searchField.frame)
        print(appInfoCollectionView.frame)
        
        XCTAssertTrue(appInfoCollectionView.frame.minX == 20)
        XCTAssertTrue(appInfoCollectionView.frame.minY == searchField.frame.maxY + 10)
        XCTAssertTrue(appInfoCollectionView.frame.width == UIScreen.main.bounds.width - 40)
        XCTAssertTrue(appInfoCollectionView.frame.height == UIScreen.main.bounds.height - 30 - 10 - ScreenUtil.shared.safeAreaTopMargin - ScreenUtil.shared.safeAreaBottomMargin)
    }
    
    func testAppInfoCollectionViewProperlySet() {
        appSearchViewController.viewDidLoad()
        appSearchViewController.view.layoutIfNeeded()
        
        let appInfoCollectionView = appSearchViewController.appInfoCollectionView
    }
    
}


struct TestUtil {
    private init() { }
    
    static let shared = TestUtil()
    
    func testViewEqualToSuperViewCenterY(_ view: UIView) -> Bool {
        guard let superview = view.superview else { return false }
        
        let frame = view.frame
        let superFrame = superview.frame
        
        return frame.minY + frame.height / 2 == superFrame.height / 2
    }
}

