//
//  SceneDelegate.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import UIKit
import Kingfisher

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinatorProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        KingfisherManager.shared.downloader.downloadTimeout = TimeInterval(KingfisherTimeout)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        let navigationController = UINavigationController()
        mainCoordinator = MainCoordinator(viewControllerFactory: ViewControllerFactory(), navigationController: navigationController)
        mainCoordinator!.start()
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

