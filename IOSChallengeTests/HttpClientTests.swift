//
//  HttpClientTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/16/23.
//

import XCTest
@testable import IOSChallenge

struct MockData {
    static let validResponseData = """
        [
            {
                "id": 1,
                "name": "Test 1"
            },
            {
                "id": 2,
                "name": "Test 2"
            }
        ]
        """.data(using: .utf8)!
    
    static let invalidResponseData = """
        {
            "invalidKey": "invalidValue"
        }
        """.data(using: .utf8)!
    
    static let emptyResponseData = Data()
}


class HttpClientTests: XCTestCase {
    struct ResponseModel: Codable {
        let id: Int
        let name: String
    }
    
    func makeSUT() -> (httpClient: HttpClient, mockURLSession: MockURLSession) {
        let mockURLSession = MockURLSession()
        var httpClient = HttpClient()
        httpClient.urlSession = mockURLSession
        return (httpClient, mockURLSession)
    }
    
    func testSendRequest_WithValidResponseData_ReturnsDecodedData() {
        let (sut, mockURLSession) = makeSUT()
        
        let responseData = MockData.validResponseData
        mockURLSession.stubbedData = responseData
        
        let expectation = self.expectation(description: "Completion called with success")
        
        sut.sendRequest(url: URL(string: "https://example.com")!, method: .get, maxRetries: 3, retryDelay: 2.0) { (result: Result<[ResponseModel], Error>) in
            switch result {
            case .success(let decodedData):
                XCTAssertEqual(decodedData.count, 2)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSendRequest_WithInvalidResponseData_ReturnsFailure() {
        // Arrange
        let (sut, mockURLSession) = makeSUT()
        
        let responseData = MockData.invalidResponseData
        mockURLSession.stubbedData = responseData
        
        let expectation = self.expectation(description: "Completion called with failure")
        
        sut.sendRequest(url: URL(string: "https://example.com")!, method: .get, maxRetries: 3, retryDelay: 2.0) { (result: Result<[ResponseModel], Error>) in
            switch result {
            case .success:
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testSendRequest_WithRetry_ReturnsSuccess() {
        let (sut, mockURLSession) = makeSUT()
        
        let responseData = MockData.validResponseData
        mockURLSession.stubbedData = responseData
        
        // Simulate a server error by returning a non-2xx status code
        let errorResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockURLSession.stubbedResponse = errorResponse
        
        let expectation = self.expectation(description: "Completion called with success")
        
        sut.sendRequest(url: URL(string: "https://example.com")!, method: .get, maxRetries: 3, retryDelay: 2.0) { (result: Result<[ResponseModel], Error>) in
            switch result {
            case .success(let decodedData):
                XCTAssertEqual(decodedData.count, 2)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
        }
        
        // Retry the request by updating the stubbed response to a successful response
        mockURLSession.stubbedResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}

