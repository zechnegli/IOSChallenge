//
//  IOSChallengeTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/16/23.
//

import XCTest
@testable import IOSChallenge

final class HomeViewControllerTests: XCTestCase {
    func makeSUT() -> HomeViewController {
        let viewModel = TableViewModel()
        let sut = HomeViewController(with: viewModel)
        sut.loadViewIfNeeded()
        return sut
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func test_viewDidLoad_creattableView() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.tableView)
    }
    
    
    func test_viewDidLoad_tableViewHasDelegate() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.tableView?.delegate)
    }

    func test_viewDidLoad_tableViewHasDatasource() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.tableView?.dataSource)
    }
    
    func test_viewDidLoad_setupTableView() {
        let sut = makeSUT()
        XCTAssertTrue(sut.tableView!.delegate!.isEqual(sut))
    }
    

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


}
