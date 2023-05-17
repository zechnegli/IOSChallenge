//
//  ViewControllerFactory.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import Foundation
import UIKit

protocol ViewControllerFactoryProtocol {
    func createHomeViewController() -> HomeViewController
    func createDetailViewController(with mealID: String?) -> DetailViewController
}

struct ViewControllerFactory: ViewControllerFactoryProtocol {
    func createHomeViewController() -> HomeViewController {
        let mealService = MealService(httpClient: HttpClient())
        let imageService = ImageService()
        let viewModel = MealTableViewModel(mealService: mealService, imageService: imageService)
        let viewController = HomeViewController(with: viewModel)
        return viewController
    }
    
    func createDetailViewController(with mealID: String?) -> DetailViewController {
        let viewModel = DetailViewModel()
        viewModel.mealID = mealID
        let viewController = DetailViewController(with: viewModel)
        return viewController
    }
}

