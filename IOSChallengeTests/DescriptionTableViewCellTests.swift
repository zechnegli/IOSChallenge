//
//  DescriptionTableViewCellTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class DescriptionTableViewCellTests: XCTestCase {
    
    private func makeSUT() -> DescriptionTableViewCell {
        return DescriptionTableViewCell(style: .default, reuseIdentifier: "TestReuseIdentifier")
    }
    
    private struct Constants {
        static let topPadding: CGFloat = 16
        static let leadingPadding: CGFloat = 16
        static let trailingPadding: CGFloat = -16
        static let bottomPadding: CGFloat = -16
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let instructionsLabelFont: UIFont = .systemFont(ofSize: 14)
        static let instructionsLabelTextColor: UIColor = .black
    }
    
    func test_DescriptionTableViewCell() {
        let sut = makeSUT()
        let descriptionLabel = sut.descriptionLabel
        
        XCTAssertEqual(descriptionLabel.font, Constants.instructionsLabelFont)
        XCTAssertEqual(descriptionLabel.textColor, Constants.instructionsLabelTextColor)
        XCTAssertEqual(descriptionLabel.numberOfLines, 0)
        XCTAssertFalse(descriptionLabel.translatesAutoresizingMaskIntoConstraints)
        
        let constraints = sut.contentView.constraints
        let topConstraint = constraints.first { $0.firstAnchor == descriptionLabel.topAnchor }
        let leadingConstraint = constraints.first { $0.firstAnchor == descriptionLabel.leadingAnchor }
        let trailingConstraint = constraints.first { $0.firstAnchor == descriptionLabel.trailingAnchor }
        let bottomConstraint = constraints.first { $0.firstAnchor == descriptionLabel.bottomAnchor }
        
        XCTAssertNotNil(topConstraint)
        XCTAssertNotNil(leadingConstraint)
        XCTAssertNotNil(trailingConstraint)
        XCTAssertNotNil(bottomConstraint)
        
        XCTAssertEqual(topConstraint?.constant, Constants.topPadding)
        XCTAssertEqual(leadingConstraint?.constant, Constants.leadingPadding)
        XCTAssertEqual(trailingConstraint?.constant, Constants.trailingPadding)
        XCTAssertEqual(bottomConstraint?.constant, Constants.bottomPadding)
    }
}
