//
//  MainCoordinator.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] { get set }
}

protocol MainCoordinatorProtocol: CoordinatorProtocol {
    func start()
    func goToDetailVC(with mealID: String?, _ image: UIImage?)
}

class MainCoordinator: MainCoordinatorProtocol {
    let viewControllerFactory: ViewControllerFactoryProtocol
    let navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol]
    
    init(viewControllerFactory: ViewControllerFactoryProtocol, navigationController: UINavigationController) {
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let homeViewController = viewControllerFactory.createHomeViewController()
        homeViewController.delegate = self
        navigationController.setViewControllers([homeViewController], animated: false)
    }
    
    func goToDetailVC(with mealID: String?, _ image: UIImage?) {
        let detailViewController = viewControllerFactory.createDetailViewController(with: mealID, image)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

extension MainCoordinator: HomeViewControllerDelegate {
    func homeViewControllerDidSelectCell(with mealID: String?, _ image: UIImage?) {
        goToDetailVC(with: mealID, image)
    }
    
}

