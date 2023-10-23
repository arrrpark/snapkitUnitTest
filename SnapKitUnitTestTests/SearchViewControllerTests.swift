//
//  SnapKitUnitTestTests.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 08/10/2023.
//

import XCTest
import RxSwift
import SnapshotTesting
@testable import SnapKitUnitTest

final class SearchViewControllerTests: XCTestCase {
    var navigationController: NavigationController!
    var appSearchViewController: SearchViewController!
    
    override func setUp() {
        super.setUp()
        
        appSearchViewController = SearchViewController(SearchViewModelForTest())
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
        appSearchViewController.viewDidLoad()
        appSearchViewController.view.layoutIfNeeded()
        
        let searchField = appSearchViewController.searchField
        let searchIcon = appSearchViewController.searchIcon
        let deleteIcon = appSearchViewController.deleteIcon
        
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
        
        XCTAssertTrue(searchIcon.contentMode == .scaleAspectFit)
        XCTAssertEqual(searchIcon.tintColor, Colors.gray.rawValue.hexStringToUIColor)
        
        XCTAssertEqual(deleteIcon.image(for: .normal), UIImage(systemName: "xmark.circle.fill"))
        XCTAssertEqual(deleteIcon.tintColor, Colors.gray.rawValue.hexStringToUIColor)
        
        XCTAssertTrue(deleteIcon.frame.width == 20)
        XCTAssertTrue(deleteIcon.frame.height == 20)
        
        let appInfoCollectionViewFlowLayout = appSearchViewController.appInfoCollectionViewFlowLayout
        XCTAssertTrue(appInfoCollectionViewFlowLayout.scrollDirection == .vertical)
        XCTAssertTrue(appInfoCollectionViewFlowLayout.minimumLineSpacing == 0)
        XCTAssertTrue(appInfoCollectionViewFlowLayout.minimumInteritemSpacing == 0)
        
        let appInfoCollectionView = appSearchViewController.appInfoCollectionView
        XCTAssertTrue(appInfoCollectionView.backgroundColor == .clear)
        
        XCTAssertTrue(appInfoCollectionView.frame.minX == 0)
        XCTAssertTrue(appInfoCollectionView.frame.minY == searchField.frame.maxY + 10)
        XCTAssertTrue(appInfoCollectionView.frame.width == UIScreen.main.bounds.width)
        XCTAssertTrue(appInfoCollectionView.frame.height == UIScreen.main.bounds.height - 30 - 10 - ScreenUtil.shared.safeAreaTopMargin - ScreenUtil.shared.safeAreaBottomMargin)
    }
    
    func testAppInfoCollectionViewProperlySet() {
        appSearchViewController.viewDidLoad()
        appSearchViewController.view.layoutIfNeeded()
        
        let appInfoCollectionView = appSearchViewController.appInfoCollectionView
        
        XCTAssertNotNil(appInfoCollectionView.delegate)
        XCTAssertNotNil(appInfoCollectionView.dataSource)
        
        appSearchViewController.searchApps("message")
        XCTAssertEqual(appSearchViewController.searchViewModel.apps.value.count, 15)
        XCTAssertEqual(appInfoCollectionView.numberOfItems(inSection: 0), 15)

        var cell = appInfoCollectionView.dataSource?.collectionView(appInfoCollectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as! AppInfoCell

        cell.layoutIfNeeded()
        
        let appContainerFrame = cell.appInfoContainerView.frame
        
        let appIconImageView = cell.appIconImageView
        var frame = appIconImageView.frame
        XCTAssertTrue(appIconImageView.contentMode == .scaleAspectFit)
        XCTAssertTrue(appIconImageView.layer.borderWidth == 1)
        XCTAssertTrue(appIconImageView.layer.borderColor == Colors.lightGray.rawValue.hexStringToUIColor.cgColor)
        XCTAssertTrue(appIconImageView.layer.cornerRadius == 5)
        XCTAssertTrue(appIconImageView.layer.masksToBounds)
        
        XCTAssertTrue(frame.minX == 20)
        XCTAssertTrue(frame.width == 60)
        XCTAssertTrue(frame.height == 60)
        
        let titleLabel = cell.titleLabel
        frame = titleLabel.frame
        XCTAssertTrue(titleLabel.font == UIFont.boldSystemFont(ofSize:14))
        XCTAssertTrue(titleLabel.numberOfLines == 1)
        XCTAssertTrue(titleLabel.textColor == .black)
        
        XCTAssertTrue(frame.minX == 60 + 20 + 15)
        XCTAssertTrue(frame.minY == titleLabel.frame.minY)
        XCTAssertTrue(frame.maxX == cell.downloadButton.frame.minX - 5)
        
        let genresLabel = cell.genresLabel
        frame = genresLabel.frame
        XCTAssertTrue(genresLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(genresLabel.textColor == Colors.deepGray.rawValue.hexStringToUIColor)
        
        XCTAssertTrue(frame.minX == titleLabel.frame.minX)
        XCTAssertTrue(frame.maxX == titleLabel.frame.maxX)
        
        let ratingView = cell.ratingView
        frame = ratingView.frame
        XCTAssertFalse(ratingView.settings.updateOnTouch)
        XCTAssertTrue(ratingView.settings.starMargin == 2)
        XCTAssertTrue(ratingView.settings.starSize == 13)
        XCTAssertTrue(ratingView.settings.filledColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.emptyBorderColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.filledBorderColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.fillMode == .precise)
        
        XCTAssertTrue(frame.maxY == appContainerFrame.maxY - 5)
        XCTAssertTrue(frame.minX == genresLabel.frame.minX)
        XCTAssertTrue(frame.width == 70)
        XCTAssertTrue(frame.height == 20)
        
        let ratingLabel = cell.ratingLabel
        frame = ratingLabel.frame
        XCTAssertTrue(ratingLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(ratingLabel.textColor == Colors.deepGray.rawValue.hexStringToUIColor)
        
        XCTAssertTrue(frame.minX == ratingView.frame.maxX + 10)
        XCTAssertTrue(frame.minY == ratingView.frame.minY)
        
        let appGuideImagesContainer = cell.appGuideImagesContainer
        frame = appGuideImagesContainer.frame
        XCTAssertTrue(frame.minY == appContainerFrame.maxY + 10)
        XCTAssertTrue(frame.minX == appContainerFrame.minX + 20)
        XCTAssertTrue(frame.maxX == appContainerFrame.maxX - 20)
        XCTAssertTrue(frame.height == AppInfoCell.appGuideWidth / 4 * 7)
        
        let appGuideImage1 = cell.appGuideImageView1
        frame = appGuideImage1.frame
        XCTAssertTrue(appGuideImage1.contentMode == .scaleAspectFit)
        XCTAssertTrue(appGuideImage1.layer.borderWidth == 1)
        XCTAssertTrue(appGuideImage1.layer.borderColor == Colors.lightGray.rawValue.hexStringToUIColor.cgColor)
        XCTAssertTrue(appGuideImage1.layer.cornerRadius == 5)
        XCTAssertTrue(appGuideImage1.layer.masksToBounds)
        
        XCTAssertTrue(frame.minX == 0)
        XCTAssertTrue(frame.minY == 0)
        XCTAssertTrue(frame.width == AppInfoCell.appGuideWidth)
        XCTAssertTrue(frame.height == appGuideImagesContainer.frame.height)
        
        let appGuideImage2 = cell.appGuideImageView2
        frame = appGuideImage2.frame
        XCTAssertTrue(appGuideImage2.contentMode == .scaleAspectFit)
        XCTAssertTrue(appGuideImage2.layer.borderWidth == 1)
        XCTAssertTrue(appGuideImage2.layer.borderColor == Colors.lightGray.rawValue.hexStringToUIColor.cgColor)
        XCTAssertTrue(appGuideImage2.layer.cornerRadius == 5)
        XCTAssertTrue(appGuideImage2.layer.masksToBounds)
        
        XCTAssertTrue(frame.minY == 0)
        XCTAssertTrue(frame.width == AppInfoCell.appGuideWidth)
        XCTAssertTrue(frame.height == appGuideImagesContainer.frame.height)
        
        let appGuideImage3 = cell.appGuideImageView3
        frame = appGuideImage3.frame
        XCTAssertTrue(appGuideImage3.contentMode == .scaleAspectFit)
        XCTAssertTrue(appGuideImage3.layer.borderWidth == 1)
        XCTAssertTrue(appGuideImage3.layer.borderColor == Colors.lightGray.rawValue.hexStringToUIColor.cgColor)
        XCTAssertTrue(appGuideImage3.layer.cornerRadius == 5)
        XCTAssertTrue(appGuideImage3.layer.masksToBounds)
        
        XCTAssertTrue(frame.minX == cell.frame.width - 40 - AppInfoCell.appGuideWidth)
        XCTAssertTrue(frame.minY == 0)
        XCTAssertTrue(frame.width == AppInfoCell.appGuideWidth)
        XCTAssertTrue(frame.height == appGuideImagesContainer.frame.height)
        
        XCTAssertTrue(appGuideImage1.superview == appGuideImagesContainer)
        XCTAssertTrue(appGuideImage2.superview == appGuideImagesContainer)
        XCTAssertTrue(appGuideImage3.superview == appGuideImagesContainer)
        
        let downloadButton = cell.downloadButton
        XCTAssertTrue(downloadButton.title(for: .normal) == "Download")
        XCTAssertTrue(downloadButton.titleColor(for: .normal) == Colors.basicTint.rawValue.hexStringToUIColor)
        XCTAssertTrue(downloadButton.backgroundColor == Colors.backgroundGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(downloadButton.layer.cornerRadius == 12)
        XCTAssertTrue(downloadButton.titleLabel?.font == UIFont.boldSystemFont(ofSize: 12))
        
        for i in 0..<self.appSearchViewController.searchViewModel.apps.value.count {
            let data = self.appSearchViewController.searchViewModel.apps.value[i]
            cell = appInfoCollectionView.dataSource?.collectionView(appInfoCollectionView, cellForItemAt: IndexPath(row: i, section: 0)) as! AppInfoCell
            
            XCTAssertTrue(cell.genresLabel.text == data.genres.genresString)
            XCTAssertTrue(cell.ratingView.rating == data.averageUserRating)
            XCTAssertTrue(cell.ratingLabel.text == data.userRatingCount.ratingString)
            
            XCTAssertTrue(cell.appIconURL?.absoluteString == data.artworkUrl512)
            XCTAssertTrue(cell.appGuideURL1?.absoluteString == data.screenshotUrls[0])
            XCTAssertTrue(cell.appGuideURL2?.absoluteString == data.screenshotUrls[1])
            XCTAssertTrue(cell.appGuideURL3?.absoluteString == data.screenshotUrls[2])
        }
    }
    
    func testNaivagetToDetailViewController() {
        appSearchViewController.viewDidLoad()
        appSearchViewController.view.layoutIfNeeded()
        
        let navigationController = appSearchViewController.navigationController
        XCTAssertNotNil(navigationController)
        XCTAssertTrue(navigationController?.viewControllers.count == 1)
        
        appSearchViewController.searchApps("message")
        appSearchViewController.appInfoCollectionView.collectionView(appSearchViewController.appInfoCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        
        var data = appSearchViewController.searchViewModel.apps.value[0]
        let expectation = expectation(description: "detail view controller pushed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            guard let selfRef = self else { return }
            XCTAssertTrue(selfRef.navigationController?.viewControllers.count == 2)
            
            let detailViewController = navigationController!.viewControllers.last as! DetailViewController
            
            detailViewController.appTitle.text = data.trackCensoredName
            detailViewController.genresLabel.text = data.genres.genresString
            detailViewController.ratingLabel.text = "\(round(data.averageUserRating * 10) / 10)"
            detailViewController.ratingView.rating = data.averageUserRating
            detailViewController.ratingCountLabel.text = "\(data.userRatingCount.ratingString) 개의 평가"
            detailViewController.ageGuideLabel.text = data.contentAdvisoryRating
            detailViewController.descriptionLabel.text = data.description
            
            detailViewController.backButton.sendActions(for: .touchUpInside)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
                guard let selfRef = self else { return }
                
                XCTAssertTrue(selfRef.navigationController?.viewControllers.count == 1)
                
                data = selfRef.appSearchViewController.searchViewModel.apps.value[1]
                selfRef.appSearchViewController.appInfoCollectionView.collectionView(selfRef.appSearchViewController.appInfoCollectionView, didSelectItemAt: IndexPath(row: 1, section: 0))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    XCTAssertTrue(navigationController?.viewControllers.count == 2)
                    let detailViewController = navigationController!.viewControllers.last as! DetailViewController
                    
                    detailViewController.appTitle.text = data.trackCensoredName
                    detailViewController.genresLabel.text = data.genres.genresString
                    detailViewController.ratingLabel.text = "\(round(data.averageUserRating * 10) / 10)"
                    detailViewController.ratingView.rating = data.averageUserRating
                    detailViewController.ratingCountLabel.text = "\(data.userRatingCount.ratingString) 개의 평가"
                    detailViewController.ageGuideLabel.text = data.contentAdvisoryRating
                    detailViewController.descriptionLabel.text = data.description
                    
                    expectation.fulfill()
                })
            })
        })
        wait(for: [expectation], timeout: 1)
    }
    
    func testInitialState() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        appSearchViewController.viewDidLoad()
        appSearchViewController.view.layoutIfNeeded()
        
        assertSnapshot(of: appSearchViewController, as: .image(size: size))
    }
    
    func testSnapShotCollectionView() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        appSearchViewController.viewDidLoad()
        appSearchViewController.view.layoutIfNeeded()
        
        appSearchViewController.searchApps("ios")
        let expectation = expectation(description: "appInfo collectionView snapshot")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            guard let self else { return }
            
            assertSnapshot(of: appSearchViewController, as: .image(size: size))
            
            appSearchViewController.appInfoCollectionView.scrollToItem(at: IndexPath(row: appSearchViewController.searchViewModel.apps.value.count - 1, section: 0), at: .bottom, animated: false)
            assertSnapshot(of: appSearchViewController, as: .image(size: size))
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.2)
    }
}
