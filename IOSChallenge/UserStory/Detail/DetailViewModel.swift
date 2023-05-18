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
    var mealID: String? {get}
    var mealDetail: MealDetail? {get}
    var delegate: DetailViewModelDelegate? {get set}
    func fetchMealDetail()
}

protocol DetailViewModelDelegate: AnyObject {
    func showError(title: String, message: String)
    func didFetchDetail()
}

class DetailViewModel: DetailViewModelProtocol {
    var image: UIImage?
    var mealID: String?
    var mealDetail: MealDetail?
    private let mealService: MealServiceProtocol
    weak var delegate: DetailViewModelDelegate?
    
    init(mealService: MealServiceProtocol) {
        self.mealService = mealService
    }
    
    func fetchMealDetail() {
        guard let mealID = mealID else {
            return
        }
        mealService.getMealDetail(mealID: mealID) {[weak self] result in
            switch result {
                case .success(let mealDetailResponse):
                    DispatchQueue.main.async {
                        if let meal = mealDetailResponse.meals?[0] {
                            self?.mealDetail = meal
                            let filteredIngredientsAndMeasures = self?.filterIngredientsAndMeasures()
                            self?.mealDetail?.ingredients = filteredIngredientsAndMeasures?.0
                            self?.mealDetail?.measures = filteredIngredientsAndMeasures?.1
                            self?.delegate?.didFetchDetail()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.delegate?.showError(title: "Error", message: error.localizedDescription)
                    }
                    
                    print(error.localizedDescription)
            }
        }
    }
    
    private func filterIngredientsAndMeasures() -> ([String]?, [String]?) {
        guard let ingredients = mealDetail?.ingredients,
              let measures = mealDetail?.measures,
              ingredients.count == measures.count else {
            return (nil, nil)
        }
        
        var filteredIngredients: [String] = []
        var filteredMeasures: [String] = []
        
        for (ingredient, measure) in zip(ingredients, measures) {
            if let ingredient = ingredient,
               let measure = measure,
               !ingredient.isEmpty && !measure.isEmpty {
                filteredIngredients.append(ingredient)
                filteredMeasures.append(measure)
            }
        }
        return (filteredIngredients, filteredMeasures)
    }
}
