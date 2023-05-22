//
//  MealTableViewModel.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation
import UIKit

protocol TableViewModelProtocol {
    var meals: [Meal] {get}
    var downloadingTasks: [IndexPath: DownloadTaskProtocol] {get}
    var delegate: MealTableViewModelDelegate? { get set}
    
    func fetchMeals()
    func cancelDownloadTask(at indexPath: IndexPath)
    func removeDownloadTask(at indexPath: IndexPath)
    func downloadThumbImage(at indexPath: IndexPath, url: String, completion: ((UIImage) -> Void)?)
    func cancelAllTasks()
}

protocol MealTableViewModelDelegate: AnyObject {
    func didLoadMeals()
    func hasEncounteredError(title: String, message: String)
}

class MealTableViewModel: TableViewModelProtocol {
    private let mealService: MealServiceProtocol
    private let imageService: ImageServiceProtocol
    private(set) var meals: [Meal] = []
    private(set) var downloadingTasks: [IndexPath: DownloadTaskProtocol] = [:]
    weak var delegate: MealTableViewModelDelegate?
        
    init(mealService: MealServiceProtocol, imageService: ImageServiceProtocol) {
        self.mealService = mealService
        self.imageService = imageService
    }
    
    public func fetchMeals() {
        mealService.getMeals(category: .dessert) {[weak self] result in
            switch result {
                case .success(let mealResponse):
                    DispatchQueue.main.async {
                        self?.meals = mealResponse.meals?
                            .filter { meal in
                                guard let mealName = meal.mealName, !mealName.isEmpty,
                                      let mealThumbURL = meal.mealThumbURL, !mealThumbURL.isEmpty else {
                                    return false
                                }
                                return true
                            }
                            .sorted() ?? []
                        self?.delegate?.didLoadMeals()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.delegate?.hasEncounteredError(title: "Error", message: error.localizedDescription)
                    }
            }
        }
    }
    
    public func downloadThumbImage(at indexPath: IndexPath, url: String, completion: ((UIImage) -> Void)?) {
        if  downloadingTasks[indexPath] != nil {
            return
        }
        let task = imageService.downdloadImageWithKingFisher(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.downloadingTasks.removeValue(forKey: indexPath)
                completion?(image)
            }
        }
        downloadingTasks[indexPath] = task
    }
    
    public func cancelDownloadTask(at indexPath: IndexPath) {
        downloadingTasks[indexPath]?.cancel()
    }
    
    public func removeDownloadTask(at indexPath: IndexPath) {
        downloadingTasks.removeValue(forKey: indexPath)
    }
    
    public func cancelAllTasks() {
        for task in downloadingTasks.values {
            task.cancel()
        }
        downloadingTasks.removeAll()
    }
}
