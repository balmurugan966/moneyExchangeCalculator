//
//  DeliveryMethodCell.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 21/12/24.
//

import UIKit

class DeliveryMethodCell: UITableViewCell {

    // UI Components
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkmarkButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15 // Create a circular button
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Cell Configuration
    var deliveryMethod: DeliveryMethod? {
        didSet {
            nameLabel.text = deliveryMethod?.name
            iconImageView.image = UIImage(systemName:  deliveryMethod?.imageName ?? "")
        }
    }

    // Selection State
    var isSelectedMethod: Bool = false {
        didSet {
            updateCellAppearance()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Add subviews
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkmarkButton)

        // Set cell corner radius
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        // Set the image tint color to green
            iconImageView.tintColor = UIColor(hex: "#13A538")
            
            // Set the background color to light gray
            iconImageView.backgroundColor = .lightGray
            
            // Set the size of the image view (Width and Height should be the same)
            let size: CGFloat = 30 // Adjust the size as needed
            iconImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: size).isActive = true
            
            // Set the cornerRadius to half of the width/height to make it circular
            iconImageView.layer.cornerRadius = size / 2
            iconImageView.layer.masksToBounds = true // Ensure the image stays inside the circle
        // Set up constraints
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),

            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            checkmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 30),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Add tap action for selection
        checkmarkButton.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }

    // Update cell appearance based on selection state
    private func updateCellAppearance() {
        if isSelectedMethod {
            // Highlight cell with green border and green checkmark
            contentView.layer.borderColor = UIColor(hex: "#13A538").cgColor
            contentView.layer.borderWidth = 1
            checkmarkButton.layer.borderColor = UIColor(hex: "#13A538").cgColor
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            // Default grey background and remove checkmark when unselected
            contentView.layer.borderColor = UIColor.gray.cgColor
            contentView.layer.borderWidth = 1
            checkmarkButton.layer.borderColor = UIColor.gray.cgColor
            checkmarkButton.setImage(nil, for: .normal)
        }
    }

    // Action to toggle selection (single selection)
    @objc private func toggleSelection() {
        isSelectedMethod.toggle()
    }
}
