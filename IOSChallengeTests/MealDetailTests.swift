//
//  MealDetailTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class MealDetailTests: XCTestCase {
    func test_DecodingMealDetail() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "MealDetailTest", ofType: "json") else {
            XCTFail("Unable to find JSON file")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let mealDetailResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
        
        guard let mealDetail = mealDetailResponse.meals?.first else {
            XCTFail("Failed to decode meal detail")
            return
        }
        
        guard let mealName = mealDetail?.mealName else {
            XCTFail("Meal name is missing")
            return
        }
        XCTAssertEqual(mealName, "Honey Yogurt Cheesecake")
        
        let expectedInstructions = "instructions"
        
        guard let instructions = mealDetail?.instructions else {
            XCTFail("Instructions are missing")
            return
        }
        
        let trimmedExpectedInstructions = expectedInstructions.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedInstructions = instructions.trimmingCharacters(in: .whitespacesAndNewlines)
        
        XCTAssertEqual(trimmedInstructions, trimmedExpectedInstructions)
        
        guard let ingredients = mealDetail?.ingredients, let measures = mealDetail?.measures else {
            XCTFail("Ingredients or measures are missing")
            return
        }
        
        XCTAssertEqual(ingredients.count, 20)
        XCTAssertEqual(measures.count, 20)
        
        guard let mealID = mealDetail?.mealID else {
            XCTFail("Meal ID is missing")
            return
        }
        XCTAssertEqual(mealID, "53007")
    }
    
    func test_DynamicCodingKeyIntValue() {
        let intValue = 10
        let key = DynamicCodingKey(intValue: intValue)
        
        XCTAssertNil(key?.stringValue)
        XCTAssertNil(key?.intValue)
    }


    static var allTests = [
        ("testDecodingMealDetail", test_DecodingMealDetail)
    ]

}
