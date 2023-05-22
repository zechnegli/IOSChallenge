//
//  MockHttp.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/21/23.
//

import Foundation
@testable import IOSChallenge

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var capturedRequest: URLRequest?
    var stubbedData: Data?
    var stubbedResponse: URLResponse?
    var stubbedError: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        capturedRequest = request
        completionHandler(stubbedData, stubbedResponse, stubbedError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol, DownloadTaskProtocol {
    var cancelCalled = false
    var resumeDidCall = false
    
    func resume() {
        resumeDidCall = true
    }
    
    func cancel() {
        cancelCalled = true
    }
}

class MockHttpClient: HttpClientProtocol {
    let sessionError: Error?
    let responseData: Data?
    
    init(sessionError: Error? = nil, responseData: Data? = nil) {
        self.sessionError = sessionError
        self.responseData = responseData
    }
    
    func sendRequest<T>(url: URL, method: HTTPMethod, maxRetries: Int, retryDelay: TimeInterval, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        if let error = sessionError {
            completion(.failure(error))
        } else if let responseData = responseData {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        } else {
            let urlRequestError = CustomError.urlParseError("Failed URL request")
            completion(.failure(urlRequestError))
        }
    }
}
