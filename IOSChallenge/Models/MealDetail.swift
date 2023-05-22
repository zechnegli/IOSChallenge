//
//  MealDetail.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

struct MealDetail: Decodable, Equatable {
    var mealName: String?
    var instructions: String?
    var ingredients: [String?]?
    var measures: [String?]?
    var mealID: String?

    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case instructions = "strInstructions"
        case mealID = "idMeal"
    }
    
    init(mealName: String?, instructions: String?, ingredients: [String?]?, measures: [String?]?, mealID: String?) {
        self.mealName = mealName
        self.instructions = instructions
        self.ingredients = ingredients
        self.measures = measures
        self.mealID = mealID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        mealName = try container.decode(String.self, forKey: .mealName)
        instructions = try container.decode(String.self, forKey: .instructions)
        mealID = try container.decode(String.self, forKey: .mealID)
        
        let nestedContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
        var dynamicIngredients: [(index: Int, ingredient: String)] = []
        var dynamicMeasures: [(index: Int, measure: String)] = []
        
        for key in nestedContainer.allKeys {
            if key.stringValue.hasPrefix("strIngredient"), let ingredient = try nestedContainer.decodeIfPresent(String.self, forKey: key) {
                let indexString = key.stringValue.replacingOccurrences(of: "strIngredient", with: "")
                let index = Int(indexString) ?? -1
                dynamicIngredients.append((index, ingredient))
            } else if key.stringValue.hasPrefix("strMeasure"), let measure = try nestedContainer.decodeIfPresent(String.self, forKey: key) {
                let indexString = key.stringValue.replacingOccurrences(of: "strMeasure", with: "")
                let index = Int(indexString) ?? -1
                dynamicMeasures.append((index, measure))
            }
        }
        
        dynamicIngredients.sort { $0.index < $1.index }
        dynamicMeasures.sort { $0.index < $1.index }
        
        ingredients = dynamicIngredients.map { $0.ingredient }
        measures = dynamicMeasures.map { $0.measure }
    }
}

struct DynamicCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) { return nil }
}
