//
//  DetailViewModelTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/21/23.
//

import XCTest
import Kingfisher
@testable import IOSChallenge

final class DetailViewModelTests: XCTestCase {
    
    class MockMealService: MealServiceProtocol {
        var getMealDetailCalled = false
        var getMealDetailMealID: String?
        var getMealDetailResult: Result<MealDetailResponse, Error> = .success(MealDetailResponse(meals: []))

        func getMealDetail(mealID: String, completion: @escaping (Result<MealDetailResponse, Error>) -> Void) {
            getMealDetailCalled = true
            getMealDetailMealID = mealID
            completion(getMealDetailResult)
        }
        
        func getMeals(category: MealCategory, completion: @escaping (Result<MealResponse, Error>) -> Void) {
            return
        }
    }

    class MockImageService: ImageServiceProtocol {
        var downloadImageCalled = false
        var downloadImageURL: String?
        var downloadImageCompletionResult: Result<UIImage, Error> = .success(UIImage())

        func downloadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> DownloadTask? {
            downloadImageCalled = true
            downloadImageURL = url
            completion(downloadImageCompletionResult)
            return nil
        }
        
        func downdloadImageWithKingFisher(url: String, completion: @escaping (UIImage) -> Void) -> Kingfisher.DownloadTask? {
              downloadImageCalled = true
              downloadImageURL = url
              switch downloadImageCompletionResult {
              case .success(let image):
                  completion(image)
              case .failure(let error):
                  print("Download image error: \(error)")
              }
              return nil
          }
    }

    class MockDetailViewModelDelegate: DetailViewModelDelegate {
        var didFetchDetailCalled = false
        var showErrorCalled = false
        var showErrorTitle: String?
        var showErrorMessage: String?

        func didFetchDetail() {
            didFetchDetailCalled = true
        }

        func showError(title: String, message: String) {
            showErrorCalled = true
            showErrorTitle = title
            showErrorMessage = message
        }
    }

    enum MockError: Error {
        case mockError
    }

    func makeSUT(mealService: MealServiceProtocol = MockMealService(),
                 imageService: ImageServiceProtocol = MockImageService()) -> DetailViewModel {
        return DetailViewModel(mealService: mealService, imageService: imageService)
    }

    // MARK: - Test cases

    func test_fetchMealDetail_callsMealServiceGetMealDetail() {
        let mealService = MockMealService()
        let sut = makeSUT(mealService: mealService)

        sut.mealID = "123"
        sut.fetchMealDetail()

        XCTAssertTrue(mealService.getMealDetailCalled)
        XCTAssertEqual(mealService.getMealDetailMealID, "123")
    }

    func test_fetchMealDetail_whenServiceSucceeds_callsDelegateDidFetchDetail() {
        let mealService = MockMealService()
        let sut = makeSUT(mealService: mealService)
        let delegate = MockDetailViewModelDelegate()
        sut.delegate = delegate
        let mealDetail = MealDetail(mealName: "Mock Meal", instructions: "Instructions", ingredients: ["Ingredient 1"], measures: ["Measure 1"], mealID: "123")
        mealService.getMealDetailResult = .success(MealDetailResponse(meals: [mealDetail]))
        
        sut.mealID = "123"
        sut.fetchMealDetail()
        
        XCTAssertTrue(mealService.getMealDetailCalled)
        XCTAssertEqual(mealService.getMealDetailMealID, "123")
        
        let delegateExpectation = expectation(description: "Delegate didFetchDetail called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(delegate.didFetchDetailCalled)
            delegateExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        XCTAssertNotNil(sut.delegate)
        XCTAssertNotNil(sut.mealDetail)
        XCTAssertEqual(sut.mealDetail?.mealName, mealDetail.mealName)
        XCTAssertEqual(sut.mealDetail?.instructions, mealDetail.instructions)
        XCTAssertEqual(sut.mealDetail?.ingredients, mealDetail.ingredients)
        XCTAssertEqual(sut.mealDetail?.measures, mealDetail.measures)
    }

    func test_fetchMealDetail_whenServiceFails_callsDelegateShowError() {
        let mealService = MockMealService()
        let sut = makeSUT(mealService: mealService)
        let delegate = MockDetailViewModelDelegate()
        sut.delegate = delegate
        let error = MockError.mockError
        mealService.getMealDetailResult = .failure(error)

        sut.mealID = "123"
        sut.fetchMealDetail()

        XCTAssertTrue(mealService.getMealDetailCalled)
        XCTAssertEqual(mealService.getMealDetailMealID, "123")

        let delegateExpectation = expectation(description: "Delegate showError called")
        delegateExpectation.expectedFulfillmentCount = 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(delegate.showErrorCalled)
            XCTAssertEqual(delegate.showErrorTitle, "Error")
            XCTAssertEqual(delegate.showErrorMessage, error.localizedDescription)
            delegateExpectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_fetchMealDetail_whenServiceSucceeds_updatesMealDetail() {
        let mealService = MockMealService()
        let sut = makeSUT(mealService: mealService)
        let delegate = MockDetailViewModelDelegate()
        sut.delegate = delegate
        let mealDetail = MealDetail(mealName: "Mock Meal", instructions: "Instructions", ingredients: ["Ingredient 1"], measures: ["Measure 1"], mealID: "123")
        mealService.getMealDetailResult = .success(MealDetailResponse(meals: [mealDetail]))

        sut.mealID = "123"
        sut.fetchMealDetail()

        XCTAssertEqual(sut.mealDetail, nil)

        let delegateExpectation = expectation(description: "Delegate didFetchDetail called")
        delegateExpectation.expectedFulfillmentCount = 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(delegate.didFetchDetailCalled)
            delegateExpectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)

        XCTAssertNotNil(sut.mealDetail)
        XCTAssertEqual(sut.mealDetail?.mealName, mealDetail.mealName)
        XCTAssertEqual(sut.mealDetail?.instructions, mealDetail.instructions)
        XCTAssertEqual(sut.mealDetail?.ingredients, mealDetail.ingredients)
        XCTAssertEqual(sut.mealDetail?.measures, mealDetail.measures)
    }

    func test_downloadThumbImage_callsImageServiceDownloadImage() {
        let imageService = MockImageService()
        let sut = makeSUT(imageService: imageService)

        sut.imageUrl = "https://example.com/mockimage.jpg"
        sut.downloadThumbImage(completion: nil)

        XCTAssertTrue(imageService.downloadImageCalled)
        XCTAssertEqual(imageService.downloadImageURL, "https://example.com/mockimage.jpg")
    }

    func test_downloadThumbImage_whenServiceSucceeds_callsCompletionWithImage() {
        let imageService = MockImageService()
        let sut = makeSUT(imageService: imageService)
        let completionExpectation = expectation(description: "Completion called")
        let expectedImage = UIImage()

        sut.imageUrl = "https://example.com/mockimage.jpg"
        sut.downloadThumbImage { image in
            XCTAssertEqual(image, expectedImage)
            completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
