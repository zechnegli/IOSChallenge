//
//  CustomErrorTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class CustomErrorTests: XCTestCase {
    func test_UrlParseErrorDescription() {
        let error = CustomError.urlParseError("Invalid URL")
        let description = error.errorDescription
        XCTAssertEqual(description, "URL parse error: Invalid URL")
    }
    
    func test_NetworkErrorDescription() {
        let error = CustomError.networkError
        let description = error.errorDescription
        XCTAssertEqual(description, "Network error occurred.")
    }
    
    func test_DecodingErrorDescription() {
        let error = CustomError.decodingError
        let description = error.errorDescription
        XCTAssertEqual(description, "Decoding error occurred.")
    }
    
    func test_ServerErrorDescription() {
        let statusCode = 404
        let error = CustomError.serverError(statusCode: statusCode)
        let description = error.errorDescription
        XCTAssertEqual(description, "Server error with status code: 404")
    }
    
    func test_UnknownErrorDescription() {
        let error = CustomError.unknownError
        let description = error.errorDescription
        XCTAssertEqual(description, "Unknown error occurred.")
    }
    
    func test_NoDataDescription() {
        let error = CustomError.noData
        let description = error.errorDescription
        XCTAssertEqual(description, "No data available.")
    }
}
