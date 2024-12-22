//
//  DropDownTableViewCell.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    // UI elements for the first section
    private let firstCellContainer = UIView()
    let firstTitleLabel = UILabel()

    // UI elements for the second section (inside firstCellContainer)
    private let secondCellContainer = UIView()
    let secondTitleLabel = UILabel()
    private let dropDownImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupFirstCell()
        setupSecondCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Cell Configuration
    var countryDetails: WelcomeElement? {
        didSet {
            secondTitleLabel.text = countryDetails?.name.common
        }
    }
    
    // Cell Configuration
    var deliveryMethodDetails: DeliveryMethod? {
        didSet {
            secondTitleLabel.text = deliveryMethodDetails?.name
        }
    }
    
    private func setupFirstCell() {
        firstCellContainer.backgroundColor = .white
        firstCellContainer.layer.cornerRadius = 10
        firstCellContainer.layer.masksToBounds = true
        firstCellContainer.layer.shadowColor = UIColor.black.cgColor
        firstCellContainer.layer.shadowOpacity = 0.1
        firstCellContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        firstCellContainer.layer.shadowRadius = 5
        contentView.addSubview(firstCellContainer)
        
        firstTitleLabel.textAlignment = .left
        firstTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        firstCellContainer.addSubview(firstTitleLabel)

        firstCellContainer.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstCellContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstCellContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstCellContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            firstCellContainer.heightAnchor.constraint(equalToConstant: 130), // Increased height for the container
            firstTitleLabel.leadingAnchor.constraint(equalTo: firstCellContainer.leadingAnchor,constant: 20),
            firstTitleLabel.topAnchor.constraint(equalTo: firstCellContainer.topAnchor)
        ])
    }
    
    private func setupSecondCell() {
        let baseColor = UIColor(hex: "#13A538")
        let lightColor = baseColor.lighter(by: 50)
        secondCellContainer.backgroundColor = lightColor
        secondCellContainer.layer.cornerRadius = 10
        secondCellContainer.layer.masksToBounds = true
        secondCellContainer.layer.shadowColor = UIColor.black.cgColor
        secondCellContainer.layer.shadowOpacity = 0.1
        secondCellContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        secondCellContainer.layer.shadowRadius = 5
        firstCellContainer.addSubview(secondCellContainer) // Now added inside firstCellContainer
        
        secondTitleLabel.text = "Title 2"
        secondTitleLabel.font = UIFont.systemFont(ofSize: 20)
        secondTitleLabel.textColor = UIColor(hex: "#13A538")
        secondCellContainer.addSubview(secondTitleLabel)
        
        dropDownImageView.image = UIImage(systemName: "arrow.down.circle.fill")
        dropDownImageView.tintColor = .white
        secondCellContainer.addSubview(dropDownImageView)
        
        secondCellContainer.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dropDownImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondCellContainer.leadingAnchor.constraint(equalTo: firstCellContainer.leadingAnchor, constant: 20),
            secondCellContainer.trailingAnchor.constraint(equalTo: firstCellContainer.trailingAnchor, constant: -20),
            secondCellContainer.topAnchor.constraint(equalTo: firstTitleLabel.bottomAnchor, constant: 10), // Below title
            secondCellContainer.heightAnchor.constraint(equalToConstant: 60), // Height of the grey container
            
            secondTitleLabel.leadingAnchor.constraint(equalTo: secondCellContainer.leadingAnchor, constant: 10), // Title starts from left with padding
            secondTitleLabel.centerYAnchor.constraint(equalTo: secondCellContainer.centerYAnchor), // Vertically centered
            
            dropDownImageView.trailingAnchor.constraint(equalTo: secondCellContainer.trailingAnchor, constant: -10), // Align to the right side
            dropDownImageView.centerYAnchor.constraint(equalTo: secondCellContainer.centerYAnchor), // Vertically center the drop down image
            dropDownImageView.widthAnchor.constraint(equalToConstant: 24),
            dropDownImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
