//
//  IngredientTableViewCell.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import UIKit

class IngredientTableViewCell: BaseTableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Constants.titleFont
        label.textColor = Constants.titleTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Constants.subtitleFont
        label.textColor = Constants.subtitleTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupLayout() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.labelTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelLeadingMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.labelTrailingMargin),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.subtitleTopMargin),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelLeadingMargin),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.labelTrailingMargin),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.labelBottomMargin)
        ])
    }
    
    func configureCell(ingredient: String, measure: String) {
        titleLabel.text = ingredient
        subtitleLabel.text = measure
    }
}

extension IngredientTableViewCell {
    private struct Constants {
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
