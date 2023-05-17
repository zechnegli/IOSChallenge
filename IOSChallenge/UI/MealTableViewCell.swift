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
        label.font = MealTableViewCellConstants.mealNameFont
        label.textColor = MealTableViewCellConstants.mealNameTextColor
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mealThumbImageView, mealNameLabel])
        stackView.axis = .horizontal
        stackView.spacing = MealTableViewCellConstants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func setupLayout() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            mealThumbImageView.widthAnchor.constraint(equalToConstant: MealTableViewCellConstants.imageWidth),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MealTableViewCellConstants.horizontalPadding),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MealTableViewCellConstants.verticalPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -MealTableViewCellConstants.horizontalPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -MealTableViewCellConstants.verticalPadding)
        ])
    }
}

struct MealTableViewCellConstants {
    static let horizontalPadding: CGFloat = 10
    static let verticalPadding: CGFloat = 10
    static let stackViewSpacing: CGFloat = 10
    static let imageWidth: CGFloat = 80
    
    static let mealNameFont: UIFont = .boldSystemFont(ofSize: 16)
    static let mealNameTextColor: UIColor = .black
}