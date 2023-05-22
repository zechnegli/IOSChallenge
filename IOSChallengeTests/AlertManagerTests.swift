//
//  AlertManagerTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class AlertManagerTests: XCTestCase {
    func makeSUT() -> AlertManagerProtocol {
        return AlertManager()
    }

    func test_showAlert_withCompletion() {
        let sut = makeSUT()
        let viewController = UIViewController()
        let expectation = self.expectation(description: "Completion called")

        sut.showAlert(from: viewController, title: "Test Title", message: "Test Message") {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
