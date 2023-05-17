//
//  ViewController.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewControllerDidSelectCell(with mealID: String?)
}

class HomeViewController: BaseViewController {
    private(set) var tableView: UITableView?
    private(set) var viewModel: TableViewModelProtocol
    weak var delegate: HomeViewControllerDelegate?
    
    init(with viewModel: TableViewModelProtocol) {
        self.viewModel = viewModel
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
        self.tableView!.register(MealTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.MealTableViewCell)
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.MealTableViewCell, for: indexPath) as! MealTableViewCell
        cell.mealNameLabel.text = viewModel.meals[indexPath.row].mealName
        cell.indexPath = indexPath
        cell.cancelTask = { [weak self] cellindex in
            guard let cellindex else {
                return
            }
            self?.viewModel.cancelDownloadTask(at: cellindex)
            self?.viewModel.removeDownloadTask(at: cellindex)
            self?.viewModel.removeDownloadImage(at: cellindex)
            
        }
        cell.mealThumbImageView.image = viewModel.getDownloadImage(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModel.downloadThumbImage(at: indexPath, url: viewModel.meals[indexPath.row].mealThumbURL, completion: nil)
        }
    }
    //bread butter pudding problem
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.getDownloadImage(at: indexPath) != nil || viewModel.getDownloadTask(at: indexPath) != nil {
            return
        }
        viewModel.downloadThumbImage(at: indexPath, url: viewModel.meals[indexPath.row].mealThumbURL) {image in
            (cell as! MealTableViewCell).mealThumbImageView.image = image
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.homeViewControllerDidSelectCell(with: viewModel.meals[indexPath.row].mealID)
//        coordinator?.goToDetailVC(viewModel.images[indexPath.row].urls.raw, viewModel.images[indexPath.row].description)
    }
}

extension HomeViewController: TableViewModelDelegate {
    func showError(title: String, message: String) {
        self.showAlert(title: title, message: message)
    }
    
    func didLoadMeals() {
        self.tableView?.reloadData()
    }
}



