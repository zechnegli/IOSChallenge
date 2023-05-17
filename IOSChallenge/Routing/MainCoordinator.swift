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
    func goToDetailVC(_ detailImageURL: String?, _ descritption: String?)
}

class MainCoordinator {
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
        navigationController.setViewControllers([homeViewController], animated: false)
    }
}

