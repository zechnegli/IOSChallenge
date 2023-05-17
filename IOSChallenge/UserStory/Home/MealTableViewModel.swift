//
//  MealTableViewModel.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import Foundation
import UIKit
import Kingfisher

protocol TableViewModelProtocol {
    var meals: [Meal] {get}
    var delegate: TableViewModelDelegate? { get set}
    func fetchMeals()
    func fetchMealDetail(mealID: Int)
    func cancelDownloadTask(at indexPath: IndexPath)
    func removeDownloadTask(at indexPath: IndexPath)
    func removeDownloadImage(at indexPath: IndexPath)
    func getDownloadImage(at indexPath: IndexPath) -> UIImage?
    func getDownloadTask(at indexPath: IndexPath) -> DownloadTask?
    func downloadThumbImage(at indexPath: IndexPath, url: String, completion: ((UIImage) -> Void)?)
    
}

protocol TableViewModelDelegate: AnyObject {
    func didLoadMeals()
    func showError(title: String, message: String)
}

class MealTableViewModel: TableViewModelProtocol {
    private let mealService: MealServiceProtocol
    private let imageService: ImageServiceProtocol
    private(set) var meals: [Meal] = []
    private(set) var downloadTasks: [IndexPath: DownloadTask] = [:]
    private(set) var predownloadImges: [IndexPath: UIImage] = [:]
    weak var delegate: TableViewModelDelegate?
        
    init(mealService: MealServiceProtocol, imageService: ImageServiceProtocol) {
        self.mealService = mealService
        self.imageService = imageService
    }
    
    public func cancelDownloadTask(at indexPath: IndexPath) {
        if downloadTasks[indexPath] != nil {
            downloadTasks[indexPath]?.cancel()
        }
    }
    
    public func removeDownloadTask(at indexPath: IndexPath) {
        if downloadTasks[indexPath] != nil {
            downloadTasks.removeValue(forKey: indexPath)
        }
    }

    public func removeDownloadImage(at indexPath: IndexPath) {
        if predownloadImges[indexPath] != nil {
            predownloadImges.removeValue(forKey: indexPath)
        }
    }
    
    public func getDownloadImage(at indexPath: IndexPath) -> UIImage? {
        //placeholder images
        return predownloadImges[indexPath]
    }
    
    public func getDownloadTask(at indexPath: IndexPath) -> DownloadTask? {
        return downloadTasks[indexPath]
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
                    switch error {
                        case CustomError.urlParseError:
                            self?.delegate?.showError(title: "Error", message: "urlParseError")
                        case CustomError.networkError:
                            self?.delegate?.showError(title: "Error", message: "networkError")
                        case CustomError.decodingError:
                            self?.delegate?.showError(title: "Error", message: "decodingError")
                        case CustomError.serverError:
                            self?.delegate?.showError(title: "Error", message: "serverError")
                        case CustomError.unknownError:
                            self?.delegate?.showError(title: "Error", message: "unknownError")
                        default:
                            self?.delegate?.showError(title: "Error", message: "Error")
                    }
                    print(error.localizedDescription)
            }
        }
    }
    
    func downloadThumbImage(at indexPath: IndexPath, url: String, completion: ((UIImage) -> Void)?) {
        if  downloadTasks[indexPath] != nil || predownloadImges[indexPath] != nil {
            return
        }
        let task = imageService.downdloadImageWithKingFisher(url: url) { [weak self] image in
            DispatchQueue.main.async {
                //all the state modifction is the main thread avoid race condition, because vewicmodel is class
                self?.predownloadImges[indexPath] = image
                self?.downloadTasks.removeValue(forKey: indexPath)
                completion?(image)
            }

        }
        
        downloadTasks[indexPath] = task
    }
    
    func fetchMealDetail(mealID: Int) {
        // Implement the logic to fetch meal details using the mealService
        // Call the appropriate method on the mealService to fetch meal details and handle the completion result
    }
    
    
}
