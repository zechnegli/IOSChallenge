//
//  MealTableViewModel.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation

protocol TableViewModelProtocol {
    var meals: [Meal] {get}
    var delegate: TableViewModelDelegate? { get set}
    func fetchMeals()
    func fetchMealDetail(mealID: Int)
}

protocol TableViewModelDelegate: AnyObject {
    func didLoadMeals()
}

class MealTableViewModel: TableViewModelProtocol {
    private let mealService: MealServiceProtocol
    private(set) var meals: [Meal] = []
    weak var delegate: TableViewModelDelegate?
        
    init(mealService: MealServiceProtocol) {
        self.mealService = mealService
    }
    
    func fetchMeals() {
        mealService.getMeals(category: .dessert) {[weak self] result in
            switch result {
                case .success(let mealResponse):
                    DispatchQueue.main.async {
                        self?.meals = mealResponse.meals.sorted()
                        self?.delegate?.didLoadMeals()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func fetchMealDetail(mealID: Int) {
        // Implement the logic to fetch meal details using the mealService
        // Call the appropriate method on the mealService to fetch meal details and handle the completion result
    }
}
