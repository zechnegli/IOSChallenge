//
//  DescriptionTableViewCell.swift
//  IOSChallenge
//
//  Created by Zecheng Li on 5/17/23.
//

import UIKit

class DescriptionTableViewCell: BaseTableViewCell {
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = DetailViewConstants.instructionsLabelFont
        label.textColor = DetailViewConstants.instructionsLabelTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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


