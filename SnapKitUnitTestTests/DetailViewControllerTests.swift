//
//  DetailViewControllerTests.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 10/10/2023.
//

import XCTest
import RxSwift
import SnapshotTesting
@testable import SnapKitUnitTest

final class DetailViewControllerTests: XCTestCase {
    var disposeBag: DisposeBag!
    var appInfo: [AppInfo]!
    var detailViewController: DetailViewController!
    var detailViewModel: DetailViewModel!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        
        let testViewModel = SearchViewModelForTest()
        testViewModel.searchApps("").subscribe { [weak self] result in
            self?.appInfo = result.results
        }.disposed(by: disposeBag)
        
        detailViewModel = DetailViewModel(appInfo: appInfo[0])
        detailViewController = DetailViewController(detailViewModel: detailViewModel)
    }
    
    override func tearDown() {
        super.tearDown()
        
        appInfo = nil
        detailViewModel = nil
        detailViewController = nil
        disposeBag = nil
    }
    
    func testDetailViewControllerProperlySet() {
        detailViewController.viewDidLoad()
        detailViewController.view.layoutIfNeeded()
        
        let headerView = detailViewController.headerView
        XCTAssertTrue(headerView.backgroundColor == .white)
        
        let backButtonConfig = detailViewController.backButtonConfig
        XCTAssertTrue(backButtonConfig.title == "Search")
        XCTAssertTrue(backButtonConfig.image == UIImage(systemName: "chevron.left"))
        XCTAssertTrue(backButtonConfig.imagePadding == 5)
        
        let backButtonView = detailViewController.backButton
        XCTAssertTrue(backButtonView.titleColor(for: .normal) == Colors.basicTint.rawValue.hexStringToUIColor)
        
        let containerView = detailViewController.containerView
        XCTAssertFalse(containerView.showsVerticalScrollIndicator)
        XCTAssertFalse(containerView.showsHorizontalScrollIndicator)
        
        let iconImageView = detailViewController.iconImageView
        XCTAssertTrue(iconImageView.clipsToBounds)
        XCTAssertTrue(iconImageView.layer.cornerRadius == 5)
        XCTAssertTrue(iconImageView.layer.borderColor == Colors.lightGray.rawValue.hexStringToUIColor.cgColor)
        XCTAssertTrue(iconImageView.layer.borderWidth == 1)
        
        let appTitle = detailViewController.appTitle
        XCTAssertTrue(appTitle.textColor == .black)
        XCTAssertTrue(appTitle.font == UIFont.boldSystemFont(ofSize: 18))
        XCTAssertTrue(appTitle.text == detailViewModel.appInfo.trackCensoredName)
        XCTAssertTrue(appTitle.numberOfLines == 1)
        
        let genresLabel = detailViewController.genresLabel
        XCTAssertTrue(genresLabel.textColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(genresLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(genresLabel.text == detailViewModel.appInfo.genres.genresString)
        
        let downloadButton = detailViewController.downloadButton
        XCTAssertTrue(downloadButton.titleColor(for: .normal) == .white)
        XCTAssertTrue(downloadButton.title(for: .normal) == "Download")
        XCTAssertTrue(downloadButton.titleLabel?.font == UIFont.boldSystemFont(ofSize: 12))
        XCTAssertTrue(downloadButton.backgroundColor == Colors.basicTint.rawValue.hexStringToUIColor)
        XCTAssertTrue(downloadButton.layer.cornerRadius == 10)
        
        let ratingLabel = detailViewController.ratingLabel
        XCTAssertTrue(ratingLabel.textColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingLabel.font == UIFont.boldSystemFont(ofSize: 18))
        XCTAssertTrue(ratingLabel.text == "\(round(detailViewModel.appInfo.averageUserRating * 10) / 10)")
        
        let ratingView = detailViewController.ratingView
        XCTAssertFalse(ratingView.settings.updateOnTouch)
        XCTAssertTrue(ratingView.settings.starSize == 18)
        XCTAssertTrue(ratingView.settings.filledColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.emptyBorderColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.filledBorderColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.fillMode == .precise)
        XCTAssertTrue(ratingView.rating == detailViewModel.appInfo.averageUserRating)
        
        let ratingCountLabel = detailViewController.ratingCountLabel
        XCTAssertTrue(ratingCountLabel.textColor == Colors.gray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingCountLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(ratingCountLabel.text == "\(detailViewModel.appInfo.userRatingCount.ratingString) RATINGS")
        
        let ageGuideLabel = detailViewController.ageGuideLabel
        XCTAssertTrue(ageGuideLabel.textColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ageGuideLabel.font == UIFont.boldSystemFont(ofSize: 18))
        XCTAssertTrue(ageGuideLabel.text == detailViewModel.appInfo.contentAdvisoryRating)
        
        let ageLabel = detailViewController.ageLabel
        XCTAssertTrue(ageLabel.textColor == Colors.gray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ageLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(ageLabel.text == "age")
        
        let detailAppImageFlowLayout = detailViewController.detailAppImageFlowLayout
        XCTAssertTrue(detailAppImageFlowLayout.scrollDirection == .horizontal)
        XCTAssertTrue(detailAppImageFlowLayout.minimumLineSpacing == 10)
        XCTAssertTrue(detailAppImageFlowLayout.minimumInteritemSpacing == 0)
        
        let detailAppImageCollectionView = detailViewController.detailAppImageCollectionView
        XCTAssertTrue(detailAppImageCollectionView.backgroundColor == .clear)
        
        let descriptionLabel = detailViewController.descriptionLabel
        XCTAssertTrue(descriptionLabel.text == detailViewModel.appInfo.description)
        XCTAssertTrue(descriptionLabel.textColor == .black)
        XCTAssertTrue(descriptionLabel.font == UIFont.systemFont(ofSize: 15))
        XCTAssertTrue(descriptionLabel.numberOfLines == 3)
        XCTAssertTrue(descriptionLabel.lineBreakMode == .byTruncatingTail)
        
        let viewMoreButton = detailViewController.viewMoreButton
        XCTAssertTrue(viewMoreButton.title(for: .normal) == "more")
        XCTAssertTrue(viewMoreButton.backgroundColor == .clear)
        XCTAssertTrue(viewMoreButton.titleLabel?.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(viewMoreButton.titleColor(for: .normal) == Colors.basicTint.rawValue.hexStringToUIColor)
    }
    
    func testDetailSnapshot() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        detailViewController.viewDidLoad()
        detailViewController.view.layoutIfNeeded()
        
        assertSnapshot(of: detailViewController, as: .image(size: size))
        
        detailViewController.viewMoreButton.sendActions(for: .touchUpInside)
        detailViewController.containerView.setContentOffset(CGPoint(x: 0, y: detailViewController.containerView.frame.height), animated: false)
        
        assertSnapshot(of: detailViewController, as: .image(size: size))
        
        detailViewModel = DetailViewModel(appInfo: appInfo[1])
        detailViewController = DetailViewController(detailViewModel: detailViewModel)
        
        detailViewController.viewDidLoad()
        detailViewController.view.layoutIfNeeded()
        
        assertSnapshot(of: detailViewController, as: .image(size: size))
        
        detailViewController.viewMoreButton.sendActions(for: .touchUpInside)
        detailViewController.containerView.setContentOffset(CGPoint(x: 0, y: detailViewController.containerView.frame.height), animated: false)
        
        assertSnapshot(of: detailViewController, as: .image(size: size))
    }
}
