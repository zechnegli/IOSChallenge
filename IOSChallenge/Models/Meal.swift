//
//  Meal.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

struct Meal: Codable, Comparable {
    let mealName: String?
    let mealThumbURL: String?
    let mealID: String?

    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealThumbURL = "strMealThumb"
        case mealID = "idMeal"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mealName = try container.decode(String.self, forKey: .mealName)
        self.mealThumbURL = try container.decode(String.self, forKey: .mealThumbURL)
        self.mealID = try container.decode(String.self, forKey: .mealID)
    }
    
    init(mealName: String?, mealThumbURL: String?, mealID: String?) {
        self.mealName = mealName
        self.mealThumbURL = mealThumbURL
        self.mealID = mealID
    }
    
    static func < (lhs: Meal, rhs: Meal) -> Bool {
        return (lhs.mealName ?? "") < (rhs.mealName ?? "")
    }
}
