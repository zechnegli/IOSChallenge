//
//  BaseTableViewCellTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/21/23.
//

import XCTest
@testable import IOSChallenge

final class BaseTableViewCellTests: XCTestCase {
    
    func makeSUT() -> MockBaseTableViewCell {
        return MockBaseTableViewCell(style: .default, reuseIdentifier: "Cell")
    }
    
    func test_initWithReuseIdentifier_callsSetupLayout() {
        let sut = makeSUT()
        
        XCTAssertTrue(sut.setupLayoutCalled)
    }
    
    class MockBaseTableViewCell: BaseTableViewCell {
        var setupLayoutCalled = false
        
        override func setupLayout() {
            setupLayoutCalled = true
        }
    }
}

