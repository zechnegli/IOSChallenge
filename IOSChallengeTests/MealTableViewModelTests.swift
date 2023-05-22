//
//  MealTableViewModelTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/21/23.
//

import XCTest
import Kingfisher

@testable import IOSChallenge

final class MealTableViewModelTests: XCTestCase {
    
    class MockMealService: MealServiceProtocol {
        func getMeals(category: MealCategory, completion: @escaping (Result<MealResponse, Error>) -> Void) {
            return
        }

        func getMealDetail(mealID: String, completion: @escaping (Result<MealDetailResponse, Error>) -> Void) {
            return
        }
    }

    class MockImageService: ImageServiceProtocol {
        func downdloadImageWithKingFisher(url: String, completion: @escaping (UIImage) -> Void) -> Kingfisher.DownloadTask? {
            return nil
        }
        
        func downloadImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
            return
        }
    }
    
    class MockDownloadTask: DownloadTaskProtocol {
        private let task: MockURLSessionDataTask
        
        init(task: MockURLSessionDataTask) {
            self.task = task
        }
        
        func cancel() {
            task.cancel()
        }
    }
    
    func makeSUT(mealService: MealServiceProtocol = MockMealService(), imageService: ImageServiceProtocol = MockImageService()) -> MealTableViewModel {
        return MealTableViewModel(mealService: mealService, imageService: imageService)
    }

    func test_cancelDownloadTask_removesTaskFromDownloadingTasks() {
        let mealService = MockMealService()
        let imageService = MockImageService()
        let viewModel = MealTableViewModel(mealService: mealService, imageService: imageService)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        viewModel.fetchMeals()
        viewModel.downloadThumbImage(at: indexPath, url: "https://example.com/mockimage.jpg") { _ in }
        viewModel.cancelDownloadTask(at: indexPath)
        
        XCTAssertNil(viewModel.downloadingTasks[indexPath])
    }


    func test_removeDownloadTask_removesTaskFromDownloadingTasks() {
        let mealService = MockMealService()
        let imageService = MockImageService()
        let viewModel = MealTableViewModel(mealService: mealService, imageService: imageService)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        viewModel.fetchMeals()
        viewModel.downloadThumbImage(at: indexPath, url: "https://example.com/mockimage.jpg") { _ in }
        viewModel.removeDownloadTask(at: indexPath)
        
        XCTAssertNil(viewModel.downloadingTasks[indexPath])
    }
}








