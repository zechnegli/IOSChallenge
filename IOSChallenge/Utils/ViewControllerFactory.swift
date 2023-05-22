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
    func createDetailViewController(with mealID: String?, _ imageUrl: String?) -> DetailViewController
}

struct ViewControllerFactory: ViewControllerFactoryProtocol {
    func createHomeViewController() -> HomeViewController {
        let mealService = MealService(httpClient: HttpClient())
        let imageService = ImageService()
        let alertManager = AlertManager()
        let viewModel = MealTableViewModel(mealService: mealService, imageService: imageService)
        let viewController = HomeViewController(with: viewModel, alertManager: alertManager)
        return viewController
    }
    
    func createDetailViewController(with mealID: String?, _ imageUrl: String?) -> DetailViewController {
        let mealService = MealService(httpClient: HttpClient())
        let imageService = ImageService()
        let alertManager = AlertManager()
        let viewModel = DetailViewModel(mealService: mealService, imageService: imageService)
        viewModel.mealID = mealID
        viewModel.imageUrl = imageUrl
        let viewController = DetailViewController(with: viewModel, alertManager: alertManager)
        return viewController
    }
}

