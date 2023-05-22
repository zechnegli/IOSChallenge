//
//  ViewControllerFactoryTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class ViewControllerFactoryTests: XCTestCase {
    func makeSUT() -> ViewControllerFactory {
        return ViewControllerFactory()
    }

    func test_createHomeViewController() {
        let sut = makeSUT()

        let homeViewController = sut.createHomeViewController()

        XCTAssertNotNil(homeViewController)
        XCTAssertTrue(type(of: homeViewController) == HomeViewController.self)
    }

    func test_createDetailViewController() {
        let sut = makeSUT()
        let mealID = "123"
        let imageUrl = "https://example.com/image.jpg"

        let detailViewController = sut.createDetailViewController(with: mealID, imageUrl)

        XCTAssertNotNil(detailViewController)
        XCTAssertTrue(type(of: detailViewController) == DetailViewController.self)
        XCTAssertEqual(detailViewController.viewModel.mealID, mealID)
        XCTAssertEqual(detailViewController.viewModel.imageUrl, imageUrl)
    }
}
