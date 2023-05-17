//
//  MealDetail.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

struct MealDetail: Codable {
    let mealName: String
    let instructions: String
    let ingredients: [String?]
    let measures: [String?]

    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case instructions = "strInstructions"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        mealName = try container.decode(String.self, forKey: .mealName)
        instructions = try container.decode(String.self, forKey: .instructions)
        ingredients = MealDetail.decodeDynamicKeys(container: container, keyPrefix: "strIngredient")
        measures = MealDetail.decodeDynamicKeys(container: container, keyPrefix: "strMeasure")
    }

    private static func decodeDynamicKeys(container: KeyedDecodingContainer<CodingKeys>, keyPrefix: String) -> [String?] {
        var dynamicKeys: [String] = []
        var index = 1
        
        while let dynamicKey = container.contains(.init(stringValue: "\(keyPrefix)\(index)")!) ? "\(keyPrefix)\(index)" : nil {
            dynamicKeys.append(dynamicKey)
            index += 1
        }
        
        return dynamicKeys.map { key in
            do {
                if let codingKey = CodingKeys(stringValue: key) {
                    return try container.decodeIfPresent(String.self, forKey: codingKey)
                } else {
                    return nil
                }
            } catch {
                print("Error decoding dynamic key: \(error) key \(key)")
                return nil
            }
        }
    }
}
