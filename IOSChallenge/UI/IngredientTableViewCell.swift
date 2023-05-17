//
//  IngredientTableViewCell.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import UIKit

class IngredientTableViewCell: BaseTableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = MealTableViewCellConstants.titleFont
        label.textColor = MealTableViewCellConstants.titleTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = MealTableViewCellConstants.subtitleFont
        label.textColor = MealTableViewCellConstants.subtitleTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupLayout() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: MealTableViewCellConstants.labelTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: MealTableViewCellConstants.labelLeadingMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: MealTableViewCellConstants.labelTrailingMargin),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: MealTableViewCellConstants.subtitleTopMargin),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: MealTableViewCellConstants.labelLeadingMargin),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: MealTableViewCellConstants.labelTrailingMargin),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: MealTableViewCellConstants.labelBottomMargin)
        ])
    }
    
    func configureCell(ingredient: String, measure: String) {
        titleLabel.text = ingredient
        subtitleLabel.text = measure
    }
}

extension IngredientTableViewCell {
    private struct MealTableViewCellConstants {
        static let titleFont: UIFont = .systemFont(ofSize: 16)
        static let subtitleFont: UIFont = .systemFont(ofSize: 14)
        static let titleTextColor: UIColor = .black
        static let subtitleTextColor: UIColor = .gray
        static let labelTopMargin: CGFloat = 8
        static let labelLeadingMargin: CGFloat = 16
        static let labelTrailingMargin: CGFloat = -16
        static let subtitleTopMargin: CGFloat = 4
        static let labelBottomMargin: CGFloat = -8
    }
}
