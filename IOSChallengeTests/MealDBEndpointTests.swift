//
//  MealDBEndpointTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/17/23.
//

import XCTest
@testable import IOSChallenge

class MealDBEndpointTests: XCTestCase {
    func test_filterByCategory() {
        let category = "dessert"
        let endpoint = MealDBEndpoint.filterByCategory(category: category)

        XCTAssertEqual(endpoint.baseURL, "https://themealdb.com/api/json/v1/1")
        XCTAssertEqual(endpoint.path, "/filter.php")
        XCTAssertEqual(endpoint.queryItems, [URLQueryItem(name: "c", value: category)])

        let expectedURL = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=dessert")
        XCTAssertEqual(endpoint.url, expectedURL)
    }

    func test_lookupByID() {
        let mealID = 12345
        let endpoint = MealDBEndpoint.lookupByID(mealID: mealID)

        XCTAssertEqual(endpoint.baseURL, "https://themealdb.com/api/json/v1/1")
        XCTAssertEqual(endpoint.path, "/lookup.php")
        XCTAssertEqual(endpoint.queryItems, [URLQueryItem(name: "i", value: "\(mealID)")])

        let expectedURL = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=12345")
        XCTAssertEqual(endpoint.url, expectedURL)
    }
}







