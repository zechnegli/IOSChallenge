//
//  ViewController.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import UIKit

class HomeViewController: UIViewController {
    private(set) var tableView: UITableView?
    private(set) var viewModel: TableViewModelProtocol
    
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
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.prefetchDataSource = self
        self.tableView!.register(MealTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.mealTableViewCell)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.mealTableViewCell, for: indexPath) as! MealTableViewCell
        cell.mealNameLabel.text = viewModel.meals[indexPath.row].mealName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
//            viewModel.downloadImage(at: indexPath, url: viewModel.images[indexPath.row].urls.thumb, completion: nil)
        }
    }
}

extension HomeViewController: TableViewModelDelegate {
    func didLoadMeals() {
        self.tableView?.reloadData()
    }
}



