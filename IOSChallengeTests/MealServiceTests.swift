//
//  MealServiceTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/21/23.
//

import XCTest
@testable import IOSChallenge

final class MealServiceTests: XCTestCase {
    private func makeSUT() -> MealService {
        let httpClient = HttpClient()
        return MealService(httpClient: httpClient)
    }

    func testGetMeals_WithValidCategory_ReturnsSuccess() {
        let sut = makeSUT()
        let expectedCategory = MealCategory.dessert

        sut.getMeals(category: expectedCategory) { result in
            switch result {
            case .success(let mealResponse):
                XCTAssertNotNil(mealResponse)
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
        }
    }

    func testGetMealDetail_WithValidMealID_ReturnsSuccess() {
        let sut = makeSUT()
        let expectedMealID = "123"

        sut.getMealDetail(mealID: expectedMealID) { result in
            switch result {
            case .success(let mealDetailResponse):
                XCTAssertNotNil(mealDetailResponse)
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
        }
    }

    func testGetMealDetail_WithInvalidMealID_ReturnsFailure() {
        let sut = makeSUT()
        let expectedMealID = "invalid_meal_id"

        sut.getMealDetail(mealID: expectedMealID) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testGetMeals_WithInvalidURL_ReturnsFailure() {
        let httpClient = MockHttpClient(sessionError: nil, responseData: nil)
        let sut = MealService(httpClient: httpClient)
        let expectedCategory = MealCategory.dessert
        
        sut.getMeals(category: expectedCategory) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "URL parse error: Failed URL request")
                if let customError = error as? CustomError {
                    XCTAssertEqual(customError, CustomError.urlParseError("Failed URL request"))
                } else {
                    XCTFail("Unexpected error type: \(error)")
                }
            }
        }
    }
}

