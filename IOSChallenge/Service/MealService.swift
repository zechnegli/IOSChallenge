//
//  MealService.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

enum MealCategory: String {
    case dessert = "Dessert"
}

protocol MealServiceProtocol {
    func getMeals(category: MealCategory, completion: @escaping (Result<MealResponse, Error>) -> Void)
    func getMealDetail(mealID: String, completion: @escaping (Result<MealDetailResponse, Error>) -> Void)
}

struct MealService: MealServiceProtocol {
    private let httpClient: HttpClientProtocol
    
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getMeals(category: MealCategory, completion: @escaping (Result<MealResponse, Error>) -> Void) {
        let endpoint = MealDBEndpoint.filterByCategory(category: category.rawValue)
        guard let url = endpoint.url else {
            completion(.failure(CustomError.urlParseError("URL parse error")))
            return
        }
        
        httpClient.sendRequest(url: url, method: .get, maxRetries: 3, retryDelay: 2.0) { (result: Result<MealResponse, Error>) in
            completion(result)
        }
    }
    
    func getMealDetail(mealID: String, completion: @escaping (Result<MealDetailResponse, Error>) -> Void) {
        let endpoint = MealDBEndpoint.lookupByID(mealID: mealID)
        guard let url = endpoint.url else {
            completion(.failure(CustomError.urlParseError("URL parse error")))
            return
        }
        
        httpClient.sendRequest(url: url, method: .get, maxRetries: 3, retryDelay: 2.0) { (result: Result<MealDetailResponse, Error>) in
            completion(result)
        }
    }
}

