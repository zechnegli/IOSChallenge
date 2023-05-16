//
//  ViewController.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/16/23.
//

import UIKit

class HomeViewController: UIViewController {
    private(set) var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureHomeViews()
    }
    
    private func configureHomeViews() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        self.tableView = UITableView()
        tableView!.rowHeight = 100
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView!)
        NSLayoutConstraint.activate([
            tableView!.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}



