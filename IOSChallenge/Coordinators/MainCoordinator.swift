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
    func goToDetailVC(with mealID: String?, _ imageUrl: String?)
}

class MainCoordinator: MainCoordinatorProtocol {
    private let viewControllerFactory: ViewControllerFactoryProtocol
    private let navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol]
    
    init(viewControllerFactory: ViewControllerFactoryProtocol, navigationController: UINavigationController) {
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    public func start() {
        let homeViewController = viewControllerFactory.createHomeViewController()
        homeViewController.delegate = self
        navigationController.setViewControllers([homeViewController], animated: false)
    }
    
    public func goToDetailVC(with mealID: String?, _ imageUrl: String?) {
        let detailViewController = viewControllerFactory.createDetailViewController(with: mealID, imageUrl)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

extension MainCoordinator: HomeViewControllerDelegate {
    func homeViewControllerDidSelectCell(with mealID: String?, _ imageUrl: String?) {
        goToDetailVC(with: mealID, imageUrl)
    }
}

