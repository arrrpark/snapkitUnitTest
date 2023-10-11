//
//  DetailViewControllerTests.swift
//  SnapKitUnitTestTests
//
//  Created by Arrr Park on 10/10/2023.
//

import XCTest
import Combine
@testable import SnapKitUnitTest

final class DetailViewControllerTests: XCTestCase {
    var cancelBag: Set<AnyCancellable>!
    var appInfo: [AppInfo]!
    var detailViewController: DetailViewController!
    var detailViewModel: DetailViewModel!
    
    override func setUp() {
        super.setUp()
        cancelBag = Set<AnyCancellable>()
        
        let testViewModel = SearchTestViewModel()
        testViewModel.searchApps("").sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] result in
            self?.appInfo = result.results
        }).store(in: &cancelBag)
        
        detailViewModel = DetailViewModel(appInfo: appInfo[0])
        detailViewController = DetailViewController(detailViewModel: detailViewModel)
    }
    
    override func tearDown() {
        super.tearDown()
        
        appInfo = nil
        detailViewModel = nil
        detailViewController = nil
        cancelBag = nil
    }
    
    func testDetailViewControllerProperlySet() {
        detailViewController.backImageView.image = UIImage(named: "dummy")
        detailViewController.viewDidLoad()
        detailViewController.view.layoutIfNeeded()
        detailViewController.backImageView.image = UIImage(systemName: "chevron.left")
        let outerView = detailViewController.view!
        
        let headerView = detailViewController.headerView
        XCTAssertTrue(headerView.backgroundColor == .white)
        
        var frame = headerView.frame
        XCTAssertTrue(frame.minY == outerView.frame.minY + ScreenUtil.shared.safeAreaTopMargin)
        XCTAssertTrue(frame.minX == outerView.frame.minX)
        XCTAssertTrue(frame.maxX == outerView.frame.maxX)
        XCTAssertTrue(frame.height == 40)
        
        let backButtonView = detailViewController.backButtonView
        XCTAssertTrue(backButtonView.isUserInteractionEnabled)
        
        frame = backButtonView.frame
        XCTAssertTrue(frame.minX == headerView.frame.minX + 10)
        XCTAssertTrue(frame.minY == 0)
        XCTAssertTrue(TestUtil.shared.testViewEqualToSuperViewCenterY(backButtonView))
        XCTAssertTrue(abs(detailViewController.searchLabel.frame.minX + detailViewController.searchLabel.frame.width - frame.width + 10) < 0.01)
        
        let backImageView = detailViewController.backImageView
        XCTAssertTrue(backImageView.image == UIImage(systemName: "chevron.left"))
        XCTAssertTrue(backImageView.contentMode == .scaleAspectFit)
        
        frame = backImageView.frame
        XCTAssertTrue(frame.width == 20)
        XCTAssertTrue(frame.height == 20)
        XCTAssertTrue(frame.minX == 0)
        XCTAssertTrue(TestUtil.shared.testViewEqualToSuperViewCenterY(backImageView))
        
        let searchLabel = detailViewController.searchLabel
        XCTAssertTrue(searchLabel.text == "Search")
        XCTAssertTrue(searchLabel.textColor == Colors.basicTint.rawValue.hexStringToUIColor)
        
        frame = searchLabel.frame
        XCTAssertTrue(abs(frame.minX - backImageView.frame.maxX + 5 - 10) < 0.01)
        XCTAssertTrue(TestUtil.shared.testViewEqualToSuperViewCenterY(searchLabel))
        
        let containerView = detailViewController.containerView
        XCTAssertFalse(containerView.showsVerticalScrollIndicator)
        XCTAssertFalse(containerView.showsHorizontalScrollIndicator)
        
        frame = containerView.frame
        XCTAssertTrue(frame.minY == ScreenUtil.shared.safeAreaTopMargin)
        XCTAssertTrue(frame.minX == 0)
        XCTAssertTrue(frame.width == UIScreen.main.bounds.width)
        XCTAssertTrue(frame.height == UIScreen.main.bounds.height - ScreenUtil.shared.safeAreaBottomMargin - ScreenUtil.shared.safeAreaTopMargin)
        
        let iconImageView = detailViewController.iconImageView
        XCTAssertTrue(iconImageView.clipsToBounds)
        XCTAssertTrue(iconImageView.layer.cornerRadius == 5)
        XCTAssertTrue(iconImageView.layer.borderColor == Colors.lightGray.rawValue.hexStringToUIColor.cgColor)
        XCTAssertTrue(iconImageView.layer.borderWidth == 1)
        
        frame = iconImageView.frame
        XCTAssertTrue(frame.width == 80)
        XCTAssertTrue(frame.height == 80)
        XCTAssertTrue(frame.minY == 50)
        XCTAssertTrue(frame.minX == containerView.frame.minX + 20)
        
        let appTitle = detailViewController.appTitle
        XCTAssertTrue(appTitle.textColor == .black)
        XCTAssertTrue(appTitle.font == UIFont.boldSystemFont(ofSize: 18))
        XCTAssertTrue(appTitle.text == detailViewModel.appInfo.trackCensoredName)
        XCTAssertTrue(appTitle.numberOfLines == 1)
        
        frame = appTitle.frame
        XCTAssertTrue(frame.minY == iconImageView.frame.minY)
        XCTAssertTrue(frame.minX == iconImageView.frame.maxX + 15)
        XCTAssertTrue(frame.width == UIScreen.main.bounds.width - 130)
        
        let genresLabel = detailViewController.genresLabel
        XCTAssertTrue(genresLabel.textColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(genresLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(genresLabel.text == detailViewModel.appInfo.genres.genresString)
        
        frame = genresLabel.frame
        XCTAssertTrue(abs(frame.minY - appTitle.frame.maxY + 5 - 10) < 0.01)
        XCTAssertTrue(frame.width == appTitle.frame.width)
        
        let downloadButton = detailViewController.downloadButton
        XCTAssertTrue(downloadButton.titleColor(for: .normal) == .white)
        XCTAssertTrue(downloadButton.title(for: .normal) == "Download")
        XCTAssertTrue(downloadButton.titleLabel?.font == UIFont.boldSystemFont(ofSize: 12))
        XCTAssertTrue(downloadButton.backgroundColor == Colors.basicTint.rawValue.hexStringToUIColor)
        XCTAssertTrue(downloadButton.layer.cornerRadius == 10)
        
        frame = downloadButton.frame
        XCTAssertTrue(frame.maxY == iconImageView.frame.maxY)
        XCTAssertTrue(frame.minX == genresLabel.frame.minX)
        XCTAssertTrue(frame.width == 85)
        XCTAssertTrue(frame.height == 25)

        let ratingLabel = detailViewController.ratingLabel
        XCTAssertTrue(ratingLabel.textColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingLabel.font == UIFont.boldSystemFont(ofSize: 18))
        XCTAssertTrue(ratingLabel.text == "\(round(detailViewModel.appInfo.averageUserRating * 10) / 10)")
        
        frame = ratingLabel.frame
        XCTAssertTrue(frame.minX == 0)
        XCTAssertTrue(TestUtil.shared.testViewEqualToSuperViewCenterY(ratingLabel))
        
        let ratingView = detailViewController.ratingView
        XCTAssertFalse(ratingView.settings.updateOnTouch)
        XCTAssertTrue(ratingView.settings.starSize == 18)
        XCTAssertTrue(ratingView.settings.filledColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.emptyBorderColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.filledBorderColor == Colors.deepGray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingView.settings.fillMode == .precise)
        XCTAssertTrue(ratingView.rating == detailViewModel.appInfo.averageUserRating)
        
        frame = ratingView.frame
        XCTAssertTrue(ratingLabel.frame.maxX + 10 - frame.minX < 0.01)
        XCTAssertTrue(frame.width == 100)
        XCTAssertTrue(frame.height == 20)
        
        let ratingCountLabel = detailViewController.ratingCountLabel
        XCTAssertTrue(ratingCountLabel.textColor == Colors.gray.rawValue.hexStringToUIColor)
        XCTAssertTrue(ratingCountLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(ratingCountLabel.text == "\(detailViewModel.appInfo.userRatingCount.ratingString) 개의 평가")
        
        frame = ratingCountLabel.frame
        XCTAssertTrue(abs(frame.minX - ratingLabel.frame.maxY + 5 + 15) < 0.01)
        XCTAssertTrue(frame.minX == ratingLabel.frame.minX)
        
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
        
        let viewMoreLabel = detailViewController.viewMoreLabel
        XCTAssertTrue(viewMoreLabel.text == "more")
        XCTAssertTrue(viewMoreLabel.backgroundColor == .white)
        XCTAssertTrue(viewMoreLabel.font == UIFont.systemFont(ofSize: 12))
        XCTAssertTrue(viewMoreLabel.textColor == Colors.basicTint.rawValue.hexStringToUIColor)
        XCTAssertTrue(viewMoreLabel.isUserInteractionEnabled == true)
        XCTAssertTrue(viewMoreLabel.gestureRecognizers!.count == 1 && viewMoreLabel.gestureRecognizers!.first is UITapGestureRecognizer)
    }
}
