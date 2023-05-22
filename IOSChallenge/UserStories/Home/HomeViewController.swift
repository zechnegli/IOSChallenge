//
//  HomeViewController.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewControllerDidSelectCell(with mealID: String?, _ imageUrl: String?)
}

class HomeViewController: UIViewController {
    var tableView: UITableView?
    private(set) var viewModel: TableViewModelProtocol
    var alertManager: AlertManagerProtocol
    weak var delegate: HomeViewControllerDelegate?
    
    init(with viewModel: TableViewModelProtocol, alertManager: AlertManagerProtocol) {
        self.viewModel = viewModel
        self.alertManager = alertManager
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Dessert"
        configureHomeViews()
        viewModel.delegate = self
        viewModel.fetchMeals()
    }

    override func viewWillAppear(_ animated: Bool) {
        continueDownloadVisibleCells()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.cancelAllTasks()
    }
    
    private func configureHomeViews() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        self.tableView = UITableView()
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.rowHeight = 100
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.prefetchDataSource = self
        self.tableView!.register(MealTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.MealTableViewCell)
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func continueDownloadVisibleCells() {
        for indexPath in tableView!.indexPathsForVisibleRows ?? [] {
            guard let cell = tableView!.cellForRow(at: indexPath) as? MealTableViewCell else {
                continue
            }
            guard let imageURL = viewModel.meals[indexPath.row].mealThumbURL else {
                return
            }
            viewModel.downloadThumbImage(at: indexPath, url: imageURL) { image in
                cell.activityIndicatorView.stopAnimating()
                cell.mealThumbImageView.image = image
            }
        }
    }
}

//MARK: TableView methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meals.count
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageURL = viewModel.meals[indexPath.row].mealThumbURL else {
                continue
            }
            viewModel.downloadThumbImage(at: indexPath, url: imageURL) {
                image in
                guard let cell = tableView.cellForRow(at: indexPath) as? MealTableViewCell  else {
                    return
                }
                cell.mealThumbImageView.image = image
                cell.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModel.cancelDownloadTask(at: indexPath)
            viewModel.removeDownloadTask(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.MealTableViewCell, for: indexPath) as! MealTableViewCell
        cell.mealNameLabel.text = viewModel.meals[indexPath.row].mealName
        cell.indexPath = indexPath
        cell.cancelTask = { [weak self] cellindex in
            guard let cellindex else {
                    return
            }
            self?.viewModel.cancelDownloadTask(at: cellindex)
            self?.viewModel.removeDownloadTask(at: cellindex)
        }
        guard let imageURL = viewModel.meals[indexPath.row].mealThumbURL else {
            return cell
        }
        viewModel.downloadThumbImage(at: indexPath, url: imageURL) {image in
            cell.activityIndicatorView.stopAnimating()
            cell.mealThumbImageView.image = image
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.homeViewControllerDidSelectCell(with: viewModel.meals[indexPath.row].mealID, viewModel.meals[indexPath.row].mealThumbURL)
    }
}

extension HomeViewController: MealTableViewModelDelegate {
    func hasEncounteredError(title: String, message: String) {
        alertManager.showAlert(from: self, title: title, message: message, completion: nil)
    }
    
    func didLoadMeals() {
        self.tableView?.reloadData()
    }
}



