//
//  AlertManager.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/19/23.
//

import Foundation
import UIKit

protocol AlertManagerProtocol {
    func showAlert(from viewController: UIViewController, title: String, message: String, completion: (() -> Void)?)
}

class AlertManager: AlertManagerProtocol {
    func showAlert(from viewController: UIViewController, title: String, message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        completion?()
    }
}
