//
//  DetailViewController.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import UIKit

class DetailViewController: UIViewController {
    private(set) var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = Constants.imageViewContentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.nameLabelFont
        label.textColor = Constants.nameLabelTextColor
        label.textAlignment = Constants.nameLabelTextAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) var ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = Constants.ingredientsTableViewSeparatorStyle
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) var viewModel: DetailViewModelProtocol
    var alertManager: AlertManagerProtocol
    private var imageViewWidthConstraint: NSLayoutConstraint?
    private var imageViewHeightConstraint: NSLayoutConstraint?
    
    
    init(with viewModel: DetailViewModelProtocol, alertManager: AlertManagerProtocol) {
        self.viewModel = viewModel
        self.alertManager = alertManager
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
        viewModel.downloadThumbImage { image in
            self.imageView.image = image
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let isLandscape = UIDevice.current.orientation.isLandscape
        
        if isLandscape {
            imageViewWidthConstraint!.constant = Constants.imageViewSizeLandscape
            imageViewHeightConstraint!.constant = Constants.imageViewSizeLandscape
        } else {
            imageViewWidthConstraint!.constant = Constants.imageViewSize
            imageViewHeightConstraint!.constant = Constants.imageViewSize
        }
        NSLayoutConstraint.activate([
            imageViewWidthConstraint!,
            imageViewHeightConstraint!
        ])
    }
    
    private func configureDetailViews() {
        imageView.image = UIImage(named: ImagePlaceHolder)
        imageView.accessibilityIdentifier = "imageView"
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(ingredientsTableView)
        
        let imageViewSize = UIDevice.current.orientation.isLandscape ? Constants.imageViewSizeLandscape : Constants.imageViewSize

        imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageViewSize)
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageViewSize)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalSpacing),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewWidthConstraint!,
            imageViewHeightConstraint!,
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.verticalSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalSpacing),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalSpacing),
            
            ingredientsTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.verticalSpacing),
            ingredientsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ingredientsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ingredientsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.IngredientTableViewCell)
        ingredientsTableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.DescriptionTableViewCell)
        ingredientsTableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.SectionHeaderView)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.mealDetail?.instructions == nil ? 0 : 1
        } else {
            return viewModel.mealDetail?.ingredients?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = DescriptionTableViewCell(style: .default, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.descriptionLabel.text = viewModel.mealDetail?.instructions
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.IngredientTableViewCell, for: indexPath) as! IngredientTableViewCell
            cell.selectionStyle = .none
            let ingredientIndex = indexPath.row
            let ingredient = viewModel.mealDetail?.ingredients?[ingredientIndex] ?? ""
            let measure = viewModel.mealDetail?.measures?[ingredientIndex] ?? ""
            cell.configureCell(ingredient: ingredient, measure: measure)
        
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifiers.SectionHeaderView) as? SectionHeaderView

        if section == 0 {
            headerView?.titleLabel.text = "Instructions"
        } else {
            headerView?.titleLabel.text = "Ingredients/Measurements"
        }

        return headerView
    }
}

extension DetailViewController {
    struct Constants {
        static let imageViewSize: CGFloat = 200
        static let imageViewSizeLandscape: CGFloat = 100
        static let imageViewContentMode: UIView.ContentMode = .scaleAspectFit
        static let nameLabelFont: UIFont = .boldSystemFont(ofSize: 20)
        static let nameLabelTextColor: UIColor = .black
        static let nameLabelTextAlignment: NSTextAlignment = .center
        static let instructionsLabelFont: UIFont = .systemFont(ofSize: 16)
        static let verticalSpacing: CGFloat = 16
        static let horizontalSpacing: CGFloat = 16
        static let instructionsLabelTextColor: UIColor = .black
        static let ingredientsTableViewSeparatorStyle: UITableViewCell.SeparatorStyle = .none
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func showError(title: String, message: String) {
        alertManager.showAlert(from: self, title: title, message: message, completion: nil)
    }
    
    func didFetchDetail() {
        ingredientsTableView.reloadData()
        nameLabel.text = viewModel.mealDetail?.mealName
    }
}
