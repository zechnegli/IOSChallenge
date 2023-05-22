//
//  MealDetailResponse.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import Foundation

import Foundation

struct MealDetailResponse: Decodable {
    let meals: [MealDetail?]?
    
    enum CodingKeys: String, CodingKey {
        case meals
    }
}
