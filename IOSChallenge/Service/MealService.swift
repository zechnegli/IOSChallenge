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
    func getMeals(category: MealCategory, completion: @escaping (Result<[Meal], Error>) -> Void)
    func getMealDetail(mealID: Int, completion: @escaping (Result<MealDetail, Error>) -> Void)
}

struct MealService: MealServiceProtocol {
    private let httpClient: HttpClientProtocol
    
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getMeals(category: MealCategory, completion: @escaping (Result<[Meal], Error>) -> Void) {
        let endpoint = MealDBEndpoint.filterByCategory(category: category.rawValue)
        guard let url = endpoint.url else {
            completion(.failure(CustomError.urlParseError("URL parse error")))
            return
        }
        
        httpClient.sendRequest(url: url, method: .get, maxRetries: 3, retryDelay: 2.0) { (result: Result<[Meal], Error>) in
            completion(result)
        }
    }
    
    func getMealDetail(mealID: Int, completion: @escaping (Result<MealDetail, Error>) -> Void) {
        let endpoint = MealDBEndpoint.lookupByID(mealID: mealID)
        guard let url = endpoint.url else {
            completion(.failure(CustomError.urlParseError("URL parse error")))
            return
        }
        
        httpClient.sendRequest(url: url, method: .get, maxRetries: 3, retryDelay: 2.0) { (result: Result<[MealDetail], Error>) in
            switch result {
            case .success(let mealDetails):
                if let mealDetail = mealDetails.first {
                    completion(.success(mealDetail))
                } else {
                    completion(.failure(CustomError.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

