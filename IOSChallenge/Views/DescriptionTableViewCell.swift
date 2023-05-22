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
        label.font = Constants.instructionsLabelFont
        label.textColor = Constants.instructionsLabelTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalPadding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DescriptionTableViewCell {
    private struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let instructionsLabelFont: UIFont = .systemFont(ofSize: 14)
        static let instructionsLabelTextColor: UIColor = .black
    }
}



