//
//  IngredientTableViewCellTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class IngredientTableViewCellTests: XCTestCase {
    private struct MealTableViewCellConstants {
        static let titleFont: UIFont = .systemFont(ofSize: 16)
        static let subtitleFont: UIFont = .systemFont(ofSize: 14)
        static let titleTextColor: UIColor = .black
        static let subtitleTextColor: UIColor = .gray
        static let labelTopMargin: CGFloat = 8
        static let labelLeadingMargin: CGFloat = 16
        static let labelTrailingMargin: CGFloat = -16
        static let subtitleTopMargin: CGFloat = 4
        static let labelBottomMargin: CGFloat = -8
    }
    
    func test_IngredientTableViewCell() {
        // Act
        let sut = makeSUT()
        sut.configureCell(ingredient: "Ingredient", measure: "Measure")
        
        // Assert
        XCTAssertEqual(sut.titleLabel.font, MealTableViewCellConstants.titleFont)
        XCTAssertEqual(sut.titleLabel.textColor, MealTableViewCellConstants.titleTextColor)
        XCTAssertEqual(sut.subtitleLabel.font, MealTableViewCellConstants.subtitleFont)
        XCTAssertEqual(sut.subtitleLabel.textColor, MealTableViewCellConstants.subtitleTextColor)
        XCTAssertEqual(sut.titleLabel.text, "Ingredient")
        XCTAssertEqual(sut.subtitleLabel.text, "Measure")
        
        // Additional assertions for layout constraints
        let constraints = sut.constraints
        let titleLabelTopConstraint = constraints.first { $0.firstAnchor == sut.titleLabel.topAnchor }
        let titleLabelLeadingConstraint = constraints.first { $0.firstAnchor == sut.titleLabel.leadingAnchor }
        let titleLabelTrailingConstraint = constraints.first { $0.firstAnchor == sut.titleLabel.trailingAnchor }
        let subtitleLabelTopConstraint = constraints.first { $0.firstAnchor == sut.subtitleLabel.topAnchor }
        let subtitleLabelLeadingConstraint = constraints.first { $0.firstAnchor == sut.subtitleLabel.leadingAnchor }
        let subtitleLabelTrailingConstraint = constraints.first { $0.firstAnchor == sut.subtitleLabel.trailingAnchor }
        let subtitleLabelBottomConstraint = constraints.first { $0.firstAnchor == sut.subtitleLabel.bottomAnchor }
        
        XCTAssertNotNil(titleLabelTopConstraint)
        XCTAssertNotNil(titleLabelLeadingConstraint)
        XCTAssertNotNil(titleLabelTrailingConstraint)
        XCTAssertNotNil(subtitleLabelTopConstraint)
        XCTAssertNotNil(subtitleLabelLeadingConstraint)
        XCTAssertNotNil(subtitleLabelTrailingConstraint)
        XCTAssertNotNil(subtitleLabelBottomConstraint)
        
        XCTAssertEqual(titleLabelTopConstraint?.constant, MealTableViewCellConstants.labelTopMargin)
        XCTAssertEqual(titleLabelLeadingConstraint?.constant, MealTableViewCellConstants.labelLeadingMargin)
        XCTAssertEqual(titleLabelTrailingConstraint?.constant, MealTableViewCellConstants.labelTrailingMargin)
        XCTAssertEqual(subtitleLabelTopConstraint?.constant, MealTableViewCellConstants.subtitleTopMargin)
        XCTAssertEqual(subtitleLabelLeadingConstraint?.constant, MealTableViewCellConstants.labelLeadingMargin)
        XCTAssertEqual(subtitleLabelTrailingConstraint?.constant, MealTableViewCellConstants.labelTrailingMargin)
        XCTAssertEqual(subtitleLabelBottomConstraint?.constant, MealTableViewCellConstants.labelBottomMargin)
    }
    
    private func makeSUT() -> IngredientTableViewCell {
        return IngredientTableViewCell(style: .default, reuseIdentifier: "TestReuseIdentifier")
    }
}
