//
//  IOSChallengeTests.swift
//  IOSChallengeTests
//
//  Created by Zecheng Li on 5/16/23.
//

import XCTest
import Kingfisher
@testable import IOSChallenge


class HomeViewControllerTests: XCTestCase {
    
    class TableViewMock: UITableView {
        var visibleCellsMock: [UITableViewCell] = []
        var indexPathsForVisibleRowsMock: [IndexPath] = []
        var reloadDataCalled = false

        override var visibleCells: [UITableViewCell] {
            return visibleCellsMock
        }

        override var indexPathsForVisibleRows: [IndexPath]? {
            return indexPathsForVisibleRowsMock
        }

        override func reloadData() {
            reloadDataCalled = true
        }

        override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
            return visibleCellsMock.first
        }
    }
    
    class MockTableViewModelProtocol: TableViewModelProtocol {
        var fetchMealsCalled = false
        var continueDownloadVisibleCellsCalled = false
        var cancelAllTasksCalled = false

        var meals: [Meal] = []
        var downloadingTasks: [IndexPath: DownloadTaskProtocol] = [:]
        weak var delegate: MealTableViewModelDelegate?

        var downloadThumbImageCalled = false
        var downloadThumbImageArguments: (indexPath: IndexPath, url: String)?
        var downloadThumbImageCompletion: ((UIImage) -> Void)?
        var cancelDownloadTaskCompletion: ((IndexPath) -> Void)?
        var removeDownloadTaskCompletion: ((IndexPath) -> Void)?

        func fetchMeals() {
            fetchMealsCalled = true
        }

        func cancelDownloadTask(at indexPath: IndexPath) {
            downloadingTasks.removeValue(forKey: indexPath)
            cancelDownloadTaskCompletion?(indexPath)
        }

        func removeDownloadTask(at indexPath: IndexPath) {
            downloadingTasks.removeValue(forKey: indexPath)
            removeDownloadTaskCompletion?(indexPath)
        }

        func downloadThumbImage(at indexPath: IndexPath, url: String, completion: ((UIImage) -> Void)?) {
            downloadThumbImageCalled = true
            downloadThumbImageArguments = (indexPath, url)
            downloadThumbImageCompletion = completion
            completion?(UIImage())
        }

        func cancelAllTasks() {
            cancelAllTasksCalled = true
            downloadingTasks.removeAll()
        }
    }

    func makeSUT() -> HomeViewController {
        let mockViewModel = MockTableViewModelProtocol()
        let mockAlertManager = AlertManager()
        let sut = HomeViewController(with: mockViewModel, alertManager: mockAlertManager)
        _ = sut.view // Load the view hierarchy
        return sut
    }
    
    func test_viewDidLoad_setsBackgroundToWhite() {
        let sut = makeSUT()
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }
    
    func test_viewDidLoad_setsNavigationBarTitle() {
        let sut = makeSUT()
        XCTAssertEqual(sut.navigationItem.title, "Dessert")
    }
    
    func test_viewDidLoad_configuresHomeViews() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.tableView?.delegate)
        XCTAssertNotNil(sut.tableView?.dataSource)
        XCTAssertEqual(sut.tableView?.rowHeight, 100)
        XCTAssertEqual(sut.tableView?.prefetchDataSource as? HomeViewController, sut)
    }
    
    func test_viewDidLoad_callsFetchMeals() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        XCTAssertTrue(mockViewModel.fetchMealsCalled)
    }
    
    func test_continueDownloadVisibleCells_downloadsImagesForVisibleCells() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol

        let mockIndexPath = IndexPath(row: 0, section: 0)
        let mockMeal = Meal(mealName: "Mock Meal", mealThumbURL: "https://example.com/mockimage.jpg", mealID: "123")
        mockViewModel.meals = [mockMeal]

        let tableViewMock = TableViewMock()
        tableViewMock.visibleCellsMock = [MealTableViewCell()]
        tableViewMock.indexPathsForVisibleRowsMock = [mockIndexPath]
        sut.tableView = tableViewMock


        mockViewModel.downloadThumbImageCompletion = { completion in
        }

        sut.viewWillAppear(false)

        XCTAssertTrue(mockViewModel.downloadThumbImageCalled)
    }
    
    func test_tableView_numberOfRowsInSection_returnsCorrectCount() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        let mockMeal1 = Meal(mealName: "Meal 1", mealThumbURL: "https://example.com/meal1.jpg", mealID: "123")
        let mockMeal2 = Meal(mealName: "Meal 2", mealThumbURL: "https://example.com/meal2.jpg", mealID: "456")
        mockViewModel.meals = [mockMeal1, mockMeal2]
        
        let numberOfRows = sut.tableView(sut.tableView!, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, 2)
    }

    func test_tableView_prefetchRowsAt_prefetchesImagesForVisibleCells() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        let mockIndexPath = IndexPath(row: 0, section: 0)
        let mockMeal = Meal(mealName: "Mock Meal", mealThumbURL: "https://example.com/mockimage.jpg", mealID: "123")
        mockViewModel.meals = [mockMeal]
        
        let tableViewMock = TableViewMock()
        tableViewMock.visibleCellsMock = [MealTableViewCell()]
        tableViewMock.indexPathsForVisibleRowsMock = [mockIndexPath]
        sut.tableView = tableViewMock
        
        sut.tableView(sut.tableView!, prefetchRowsAt: [mockIndexPath])
        
        XCTAssertTrue(mockViewModel.downloadThumbImageCalled)
    }

    func test_tableView_cancelPrefetchingForRowsAt_cancelsDownloadTasksForIndexPaths() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        let mockIndexPath = IndexPath(row: 0, section: 0)
        
        let tableViewMock = TableViewMock()
        sut.tableView = tableViewMock
        
        var cancelDownloadTaskCalled = false
        var removeDownloadTaskCalled = false
        
        mockViewModel.cancelDownloadTaskCompletion = { indexPath in
            XCTAssertEqual(indexPath, mockIndexPath)
            cancelDownloadTaskCalled = true
        }
        
        mockViewModel.removeDownloadTaskCompletion = { indexPath in
            XCTAssertEqual(indexPath, mockIndexPath)
            removeDownloadTaskCalled = true
        }
        
        sut.tableView(sut.tableView!, cancelPrefetchingForRowsAt: [mockIndexPath])
        
        XCTAssertTrue(cancelDownloadTaskCalled)
        XCTAssertTrue(removeDownloadTaskCalled)
    }

    func test_tableView_cellForRowAt_returnsConfiguredCell() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        let mockIndexPath = IndexPath(row: 0, section: 0)
        let mockMeal = Meal(mealName: "Mock Meal", mealThumbURL: "https://example.com/mockimage.jpg", mealID: "123")
        mockViewModel.meals = [mockMeal]
        
        let tableView = UITableView()
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.MealTableViewCell)
        
        let cell = sut.tableView(tableView, cellForRowAt: mockIndexPath) as! MealTableViewCell
        
        XCTAssertEqual(cell.mealNameLabel.text, "Mock Meal")
        XCTAssertEqual(cell.indexPath, mockIndexPath)
        
        XCTAssertTrue(mockViewModel.downloadThumbImageCalled)
        XCTAssertEqual(mockViewModel.downloadThumbImageArguments?.indexPath, mockIndexPath)
        XCTAssertEqual(mockViewModel.downloadThumbImageArguments?.url, "https://example.com/mockimage.jpg")
    }
    
    func test_tableView_cellForRowAt_configuresCellCorrectly() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        let mockIndexPath = IndexPath(row: 0, section: 0)
        let mockMeal = Meal(mealName: "Mock Meal", mealThumbURL: "https://example.com/mockimage.jpg", mealID: "123")
        mockViewModel.meals = [mockMeal]

        let tableView = UITableView()
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.MealTableViewCell) // Register the cell class

        let cell = sut.tableView(tableView, cellForRowAt: mockIndexPath) as! MealTableViewCell

        XCTAssertEqual(cell.mealNameLabel.text, "Mock Meal")
        XCTAssertEqual(cell.indexPath, mockIndexPath)

        XCTAssertTrue(mockViewModel.downloadThumbImageCalled)
        XCTAssertEqual(mockViewModel.downloadThumbImageArguments?.indexPath, mockIndexPath)
        XCTAssertEqual(mockViewModel.downloadThumbImageArguments?.url, "https://example.com/mockimage.jpg")

        var cancelTaskCalled = false
        cell.cancelTask = { indexPath in
            XCTAssertEqual(indexPath, mockIndexPath)
            cancelTaskCalled = true
        }

        cell.prepareForReuse()

        XCTAssertTrue(cancelTaskCalled)
    }

    func test_tableView_didSelectRowAt_callsDelegateMethod() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        let mockIndexPath = IndexPath(row: 0, section: 0)
        let mockMeal = Meal(mealName: "Mock Meal", mealThumbURL: "https://example.com/mockimage.jpg", mealID: "123")
        mockViewModel.meals = [mockMeal]

        let tableViewMock = TableViewMock()
        sut.tableView = tableViewMock

        let delegateMock = HomeViewControllerDelegateMock()
        sut.delegate = delegateMock

        sut.tableView(tableViewMock, didSelectRowAt: mockIndexPath)

        XCTAssertTrue(delegateMock.homeViewControllerDidSelectCellCalled)
        XCTAssertEqual(delegateMock.selectedMealID, "123")
        XCTAssertEqual(delegateMock.selectedMealThumbURL, "https://example.com/mockimage.jpg")
    }

    class HomeViewControllerDelegateMock: HomeViewControllerDelegate {
        var homeViewControllerDidSelectCellCalled = false
        var selectedMealID: String?
        var selectedMealThumbURL: String?

        func homeViewControllerDidSelectCell(with mealID: String?, _ imageUrl: String?) {
            homeViewControllerDidSelectCellCalled = true
            selectedMealID = mealID
            selectedMealThumbURL = imageUrl
        }
    }
    
    func test_viewDidDisappear_callsCancelAllTasks() {
        let sut = makeSUT()
        let mockViewModel = sut.viewModel as! MockTableViewModelProtocol
        XCTAssertFalse(mockViewModel.cancelAllTasksCalled)
        
        sut.viewDidDisappear(false)
        
        XCTAssertTrue(mockViewModel.cancelAllTasksCalled)
    }

}

