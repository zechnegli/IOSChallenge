//
//  DetailViewController.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import UIKit

class DetailViewController: BaseViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = DetailViewConstants.imageViewContentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = DetailViewConstants.nameLabelFont
        label.textColor = DetailViewConstants.nameLabelTextColor
        label.textAlignment = DetailViewConstants.nameLabelTextAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = DetailViewConstants.ingredientsTableViewSeparatorStyle
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) var viewModel: DetailViewModelProtocol
    
    init(with viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        configureDetailViews()
        viewModel.fetchMealDetail()
    }
    
    private func configureDetailViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(ingredientsTableView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: DetailViewConstants.imageViewSize),
            imageView.heightAnchor.constraint(equalToConstant: DetailViewConstants.imageViewSize),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            ingredientsTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            ingredientsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ingredientsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ingredientsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set the data from the view model
        imageView.image = viewModel.image
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.IngredientTableViewCell)
        ingredientsTableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.DescriptionTableViewCell)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.mealDetail?.ingredients?.count ?? 0) +  (viewModel.mealDetail?.instructions == nil ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = DescriptionTableViewCell(style: .default, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.descriptionLabel.text = viewModel.mealDetail?.instructions
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.IngredientTableViewCell, for: indexPath) as! IngredientTableViewCell
            cell.selectionStyle = .none
            let ingredientIndex = indexPath.row - 1
            let ingredient = viewModel.mealDetail?.ingredients?[ingredientIndex] ?? ""
            let measure = viewModel.mealDetail?.measures?[ingredientIndex] ?? ""
            
            cell.configureCell(ingredient: ingredient, measure: measure)
            
            return cell
        }
    }
}

struct DetailViewConstants {
    static let imageViewSize: CGFloat = 200
    static let imageViewContentMode: UIView.ContentMode = .scaleAspectFit
    static let nameLabelFont: UIFont = .boldSystemFont(ofSize: 20)
    static let nameLabelTextColor: UIColor = .black
    static let nameLabelTextAlignment: NSTextAlignment = .center
    static let instructionsLabelFont: UIFont = .systemFont(ofSize: 16)
    static let instructionsLabelTextColor: UIColor = .black
    static let ingredientsTableViewSeparatorStyle: UITableViewCell.SeparatorStyle = .none
}

extension DetailViewController: DetailViewModelDelegate {
    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func didFetchDetail() {
        ingredientsTableView.reloadData()
        nameLabel.text = viewModel.mealDetail?.mealName
    }
}
