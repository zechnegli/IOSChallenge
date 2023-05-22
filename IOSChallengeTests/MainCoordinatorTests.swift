//
//  MainCoordinatorTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/21/23.
//

import XCTest
@testable import IOSChallenge

final class MainCoordinatorTests: XCTestCase {
    
    func makeSUT(viewControllerFactory: ViewControllerFactoryProtocol, navigationController: UINavigationController) -> MainCoordinator {
        return MainCoordinator(viewControllerFactory: viewControllerFactory, navigationController: navigationController)
    }
    
    func test_start_setsRootViewController() {
        let navigationController = UINavigationController()
        let viewControllerFactory = ViewControllerFactory()
        let sut = makeSUT(viewControllerFactory: viewControllerFactory, navigationController: navigationController)

        sut.start()

        XCTAssertTrue(navigationController.viewControllers.count == 1)
        XCTAssertTrue(navigationController.viewControllers.first is HomeViewController)
    }

    func test_goToDetailVC_pushesDetailViewController() {
        let navigationController = UINavigationController()
        let viewControllerFactory = ViewControllerFactory()
        let sut = makeSUT(viewControllerFactory: viewControllerFactory, navigationController: navigationController)

        sut.goToDetailVC(with: "123", "https://example.com/image.jpg")

        XCTAssertTrue(navigationController.viewControllers.count == 1)
        XCTAssertTrue(navigationController.viewControllers.last is DetailViewController)
    }
}
