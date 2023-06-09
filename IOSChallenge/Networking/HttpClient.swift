//
//  APIClient.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol HttpClientProtocol {
    func sendRequest<T>(url: URL, method: HTTPMethod, maxRetries: Int, retryDelay: TimeInterval, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable
}

struct HttpClient: HttpClientProtocol {
    var urlSession: URLSessionProtocol = URLSession.shared
    
    /**
     Sends a network request to the specified URL with query parameters and HTTP method.
     This method supports retry mechanism for failed requests.

     - Parameters:
        - url: The URL to send the request to.
        - method: The HTTP method to be used for the request.
        - maxRetries: The maximum number of retries to attempt for failed requests.
        - retryDelay: The delay interval between retries.
        - completion: The completion closure to be called when the request is finished.
                      It provides a result containing either the decoded response or an error.

     - Throws: An error of type `CustomError` if there is a failure during the request.
     */
    func sendRequest<T>(url: URL, method: HTTPMethod, maxRetries: Int, retryDelay: TimeInterval, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        var currentRetry = 0
        
        func performRequest() {
            let request = URLRequest(url: url)
            let task = urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    if currentRetry < maxRetries {
                        currentRetry += 1
                        print("Retry attempt \(currentRetry)...")
                        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                            performRequest()
                        }
                    } else {
                        completion(.failure(error))
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    if currentRetry < maxRetries {
                        currentRetry += 1
                        print("Retry attempt \(currentRetry)...")
                        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                            performRequest() // Retry the request after the delay
                        }
                    } else {
                        completion(.failure(CustomError.serverError(statusCode: httpResponse.statusCode)))
                    }
                    return
                }
                
                guard let data = data else {
                    completion(.failure(CustomError.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
        
        performRequest()
    }
}
