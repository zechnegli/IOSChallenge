//
//  MealDBEndpoint.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation
enum MealDBEndpoint {
    case filterByCategory(category: String)
    case lookupByID(mealID: String)
    
    var baseURL: String {
        return "https://themealdb.com/api/json/v1/1"
    }
    
    var path: String {
        switch self {
        case .filterByCategory:
            return "/filter.php"
        case .lookupByID:
            return "/lookup.php"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .filterByCategory(let category):
            return [URLQueryItem(name: "c", value: category)]
        case .lookupByID(let mealID):
            return [URLQueryItem(name: "i", value: mealID)]
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
