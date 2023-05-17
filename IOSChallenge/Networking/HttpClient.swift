//
//  APIClient.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation
protocol HttpClient {
    func sendRequest<T>(host: String, path: String, queryParameters: [URLQueryItem], method: HTTPMethod, maxRetries: Int, retryDelay: TimeInterval, completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable, T: Encodable
}

struct URLSessionHttpClient: HttpClient {
    /**
     Sends a network request to the specified URL with query parameters and HTTP method.
     This method supports retry mechanism for failed requests.

     - Parameters:
        - host: The host of the URL.
        - path: The path of the URL.
        - queryParameters: The query parameters to be included in the URL.
        - method: The HTTP method to be used for the request.
        - maxRetries: The maximum number of retries to attempt for failed requests.
        - retryDelay: The delay interval between retries.
        - completion: The completion closure to be called when the request is finished.
                      It provides a result containing either the decoded response or an error.

     - Throws: An error of type `CustomError` if there is a failure during the request.
     */
    func sendRequest<T>(host: String, path: String, queryParameters: [URLQueryItem], method: HTTPMethod, maxRetries: Int, retryDelay: TimeInterval, completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable, T: Encodable {
        var components = URLComponents()
        components.host = host
        components.scheme = "https"
        components.path = path
        components.queryItems = queryParameters
        
        guard let url = components.url else {
            completion(.failure(CustomError.urlParseError("Url parse error")))
            return
        }
        print(url)
        
        var currentRetry = 0
        
        func performRequest() {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    if currentRetry < maxRetries {
                        currentRetry += 1
                        print("Retry attempt \(currentRetry)...")
                        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                            performRequest() // Retry the request after the delay
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
                    let decodedData = try JSONDecoder().decode([T].self, from: data)
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
