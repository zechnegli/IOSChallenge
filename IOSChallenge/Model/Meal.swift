//
//  Meal.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

struct Meal: Codable {
    let mealName: String
    let mealThumbURL: String
    let mealID: Int

    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealThumbURL = "strMealThumb"
        case mealID = "idMeal"
    }
}
