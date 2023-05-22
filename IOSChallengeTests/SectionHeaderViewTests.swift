//
//  SectionHeaderViewTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class SectionHeaderViewTests: XCTestCase {
    
    private func makeSUT() -> SectionHeaderView {
        return SectionHeaderView(reuseIdentifier: "TestReuseIdentifier")
    }
    
    private struct SectionHeaderViewConstants {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 8
        static let titleLabelFont: UIFont = .boldSystemFont(ofSize: 16)
        static let titleLabelTextColor: UIColor = .black
    }
    
    func test_SectionHeaderView() {
        let sut = makeSUT()
        
        let titleLabel = sut.titleLabel
        
        XCTAssertEqual(titleLabel.font, SectionHeaderViewConstants.titleLabelFont)
        XCTAssertEqual(titleLabel.textColor, SectionHeaderViewConstants.titleLabelTextColor)
        XCTAssertEqual(titleLabel.textAlignment, .center)
        XCTAssertFalse(titleLabel.translatesAutoresizingMaskIntoConstraints)
        
        let constraints = sut.contentView.constraints
        let leadingConstraint = constraints.first { $0.firstAnchor == titleLabel.leadingAnchor }
        let trailingConstraint = constraints.first { $0.firstAnchor == titleLabel.trailingAnchor }
        let topConstraint = constraints.first { $0.firstAnchor == titleLabel.topAnchor }
        let bottomConstraint = constraints.first { $0.firstAnchor == titleLabel.bottomAnchor }
        
        XCTAssertNotNil(leadingConstraint)
        XCTAssertNotNil(trailingConstraint)
        XCTAssertNotNil(topConstraint)
        XCTAssertNotNil(bottomConstraint)
        
        XCTAssertEqual(leadingConstraint?.constant, SectionHeaderViewConstants.horizontalPadding)
        XCTAssertEqual(trailingConstraint?.constant, -SectionHeaderViewConstants.horizontalPadding)
        XCTAssertEqual(topConstraint?.constant, SectionHeaderViewConstants.verticalPadding)
        XCTAssertEqual(bottomConstraint?.constant, -SectionHeaderViewConstants.verticalPadding)
    }
}
