//
//  MealTableViewCellTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/20/23.
//

import XCTest
@testable import IOSChallenge

final class MealTableViewCellTests: XCTestCase {
    func test_prepareForReuse() {
        let sut = MealTableViewCell()
        sut.mealThumbImageView.image = UIImage(named: "someImage")
        sut.indexPath = IndexPath(row: 0, section: 0)
        sut.cancelTask = { _ in }

        sut.prepareForReuse()

        XCTAssertNil(sut.mealThumbImageView.image)
        XCTAssertNil(sut.indexPath)
        XCTAssertNil(sut.cancelTask)
        XCTAssertTrue(sut.activityIndicatorView.isAnimating)
    }
}
