//
//  MealModelTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/19/23.
//

import XCTest
@testable import IOSChallenge

final class MealModelTests: XCTestCase {
    func test_DecodingMealResponse() throws {
        let json = """
        {
            "meals": [
                {
                    "strMeal": "Apam balik",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                    "idMeal": "53049"
                },
                {
                    "strMeal": "Apple & Blackberry Crumble",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
                    "idMeal": "52893"
                }
            ]
        }
        """
        let data = Data(json.utf8)

        let sut = try JSONDecoder().decode(MealResponse.self, from: data)

        XCTAssertEqual(sut.meals?.count, 2)
        XCTAssertEqual(sut.meals?[0].mealName, "Apam balik")
        XCTAssertEqual(sut.meals?[0].mealThumbURL, "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        XCTAssertEqual(sut.meals?[0].mealID, "53049")
        XCTAssertEqual(sut.meals?[1].mealName, "Apple & Blackberry Crumble")
        XCTAssertEqual(sut.meals?[1].mealThumbURL, "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
        XCTAssertEqual(sut.meals?[1].mealID, "52893")
    }
    
    func testMealComparison() {
        let meal1 = Meal(mealName: "Apple Pie", mealThumbURL: "", mealID: "1")
        let meal2 = Meal(mealName: "Banana Bread", mealThumbURL: "", mealID: "2")
        let meal3 = Meal(mealName: "Carrot Cake", mealThumbURL: "", mealID: "3")

        XCTAssertTrue(meal1 < meal2)
        XCTAssertFalse(meal2 < meal1)
        XCTAssertFalse(meal1 < meal1)

        XCTAssertTrue(meal2 < meal3)
        XCTAssertFalse(meal3 < meal2)
        XCTAssertFalse(meal2 < meal2)

        XCTAssertTrue(meal1 < meal3)
        XCTAssertFalse(meal3 < meal1)
    }

    static var allTests = [
        ("testDecodingMealResponse", test_DecodingMealResponse)
    ]
}
