//
//  DetailViewModel.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import Foundation
import UIKit

protocol DetailViewModelProtocol {
    var image: UIImage? {get}
    var mealName: String? {get}
    var instructions: String? {get}
    var ingredients: [String?] {get}
    var measures: [String?] {get}
}

class DetailViewModel: DetailViewModelProtocol {
    var image: UIImage?
    var mealName: String?
    var instructions: String?
    var ingredients: [String?] = []
    var measures: [String?] = []
    
}
