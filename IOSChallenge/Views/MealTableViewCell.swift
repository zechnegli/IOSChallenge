//
//  MealTableViewCell.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import UIKit

class MealTableViewCell: BaseTableViewCell {
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.mealNameFont
        label.textColor = Constants.mealNameTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mealThumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mealThumbImageView, mealNameLabel])
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var indexPath: IndexPath?
    var cancelTask: ((IndexPath?) -> Void)?
    
    override func setupLayout() {
        contentView.addSubview(stackView)
        contentView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            mealThumbImageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalPadding),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: mealThumbImageView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: mealThumbImageView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealThumbImageView.image = nil
        cancelTask?(indexPath)
        cancelTask = nil
        indexPath = nil
        activityIndicatorView.startAnimating()
    }
}

extension MealTableViewCell {
    private struct Constants {
        static let horizontalPadding: CGFloat = 10
        static let verticalPadding: CGFloat = 10
        static let stackViewSpacing: CGFloat = 10
        static let imageWidth: CGFloat = 80
        static let mealNameFont: UIFont = .boldSystemFont(ofSize: 16)
        static let mealNameTextColor: UIColor = .black
    }
}
