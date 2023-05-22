//
//  DetailViewControllerTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/21/23.
//

import XCTest
@testable import IOSChallenge

final class DetailViewControllerTests: XCTestCase {
    
    // MARK: - Mocks

    class MockDetailViewModel: DetailViewModelProtocol {
        var image: UIImage?
        var mealID: String?
        var imageUrl: String?
        var mealDetail: MealDetail?
        weak var delegate: DetailViewModelDelegate?
        
        var fetchMealDetailCalled = false
        var downloadThumbImageCalled = false
        
        func fetchMealDetail() {
            fetchMealDetailCalled = true
        }
        
        func downloadThumbImage(completion: ((UIImage) -> Void)?) {
            downloadThumbImageCalled = true
        }
    }

    class MockAlertManager: AlertManagerProtocol {
        var showAlertCalled = false
        var showAlertTitle: String?
        var showAlertMessage: String?
        
        func showAlert(from viewController: UIViewController, title: String, message: String, completion: (() -> Void)?) {
            showAlertCalled = true
            showAlertTitle = title
            showAlertMessage = message
        }
    }
    
    func makeSUT(viewModel: DetailViewModelProtocol = MockDetailViewModel(),
                 alertManager: AlertManagerProtocol = MockAlertManager()) -> DetailViewController {
        let sut = DetailViewController(with: viewModel, alertManager: alertManager)
        sut.loadViewIfNeeded()
        return sut
    }
    
    func test_viewDidLoad_callsFetchMealDetail() {
        let viewModel = MockDetailViewModel()
        let sut = makeSUT(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(viewModel.fetchMealDetailCalled)
    }
    
    func test_viewDidLoad_callsDownloadThumbImage() {
        let viewModel = MockDetailViewModel()
        let sut = makeSUT(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(viewModel.downloadThumbImageCalled)
    }

    func test_configureDetailViews_setsImageViewImage() {
        let viewModel = MockDetailViewModel()
        let sut = makeSUT(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.imageView.image, UIImage(named: "placeholder-image"))
    }
    
    func test_tableView_numberOfRowsInSection_whenSection0AndInstructionsNotNil_returns1() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: "Instructions", ingredients: nil, measures: nil, mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_tableView_numberOfRowsInSection_whenSection0AndInstructionsNil_returns0() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: nil, ingredients: nil, measures: nil, mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func test_tableView_numberOfRowsInSection_whenSection1AndIngredientsNotNil_returnsNumberOfIngredients() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: nil, ingredients: ["Ingredient 1", "Ingredient 2"], measures: ["Measure 1", "Measure 2"], mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 1)
        
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func test_tableView_numberOfRowsInSection_whenSection1AndIngredientsNil_returns0() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: nil, ingredients: nil, measures: nil, mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 1)
        
        XCTAssertEqual(numberOfRows, 0)
    }
    
    func test_tableView_cellForRowAt_whenSection0AndInstructionsNotNil_returnsDescriptionTableViewCell() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: "Instructions", ingredients: nil, measures: nil, mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath)
        
        XCTAssertTrue(cell is DescriptionTableViewCell)
    }
    
    func test_tableView_cellForRowAt_whenSection0AndInstructionsNotNil_setsCellDescriptionText() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: "Instructions", ingredients: nil, measures: nil, mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! DescriptionTableViewCell
        
        XCTAssertEqual(cell.descriptionLabel.text, "Instructions")
    }
    
    func test_tableView_cellForRowAt_whenSection1AndIngredientsNotNil_returnsIngredientTableViewCell() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: nil, ingredients: ["Ingredient 1"], measures: ["Measure 1"], mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath)
        
        XCTAssertTrue(cell is IngredientTableViewCell)
    }
    
    func test_tableView_cellForRowAt_whenSection1AndIngredientsNotNil_setsCellIngredientAndMeasure() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: nil, ingredients: ["Ingredient 1"], measures: ["Measure 1"], mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! IngredientTableViewCell
        
        XCTAssertEqual(cell.titleLabel.text, "Ingredient 1")
        XCTAssertEqual(cell.subtitleLabel.text, "Measure 1")
    }
    
    func test_tableView_numberOfSections_returns2() {
        let viewModel = MockDetailViewModel()
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let numberOfSections = sut.numberOfSections(in: tableView)
        
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func test_tableView_viewForHeaderInSection_whenSection0_returnsSectionHeaderViewWithTitleInstructions() {
        let viewModel = MockDetailViewModel()
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let view = sut.tableView(tableView, viewForHeaderInSection: 0) as? SectionHeaderView
        
        XCTAssertEqual(view?.titleLabel.text, "Instructions")
    }
    
    func test_tableView_viewForHeaderInSection_whenSection1_returnsSectionHeaderViewWithTitleIngredientsMeasurements() {
        let viewModel = MockDetailViewModel()
        let sut = makeSUT(viewModel: viewModel)
        let tableView = sut.ingredientsTableView
        
        let view = sut.tableView(tableView, viewForHeaderInSection: 1) as? SectionHeaderView
        
        XCTAssertEqual(view?.titleLabel.text, "Ingredients/Measurements")
    }
    
    func test_didFetchDetail_setsNameLabel() {
        let viewModel = MockDetailViewModel()
        viewModel.mealDetail = MealDetail(mealName: "Mock Meal", instructions: nil, ingredients: nil, measures: nil, mealID: "123")
        let sut = makeSUT(viewModel: viewModel)
        
        sut.didFetchDetail()
        
        XCTAssertEqual(sut.nameLabel.text, "Mock Meal")
    }
    
    func test_showError_callsAlertManagerToShowAlert() {
        let viewModel = MockDetailViewModel()
        let alertManager = MockAlertManager()
        let sut = makeSUT(viewModel: viewModel, alertManager: alertManager)
        
        sut.showError(title: "Error", message: "Error message")
        
        XCTAssertTrue(alertManager.showAlertCalled)
        XCTAssertEqual(alertManager.showAlertTitle, "Error")
        XCTAssertEqual(alertManager.showAlertMessage, "Error message")
        
    }
}


