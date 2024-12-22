//
//  ExchangeRateTableViewCell.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {
    
    // UI elements for the first section
    private let firstCellContainer = UIView()
    let firstTitleLabel = UILabel()
    let fouthTitleLabel = UILabel()
    let titleHeaderLabel = UILabel()
    let countryCodeLabel = UILabel()
    // UI elements for the second section (inside firstCellContainer)
    private let secondCellContainer = UIView()
    private let secondTitleLabel = UILabel()
    private let dropDownImageView = UIImageView()
    let additionalLabel = UILabel() // Use class-level additionalLabel here
    let exchangeMoneyLabel = UILabel()
    let thirdCellContainer = UIView()
    let countryIcon = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupFirstCell()
        setupSecondCell()
        setupThirdCell()
        setupTitleHeader()
        setupFourthCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Cell Configuration
    var countryDetails: WelcomeElement? {
        didSet {
            countryIcon.loadImage(from: countryDetails?.flags.png ?? "")
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
            firstCellContainer.heightAnchor.constraint(equalToConstant: 400), // Increased height for the container
            firstTitleLabel.leadingAnchor.constraint(equalTo: firstCellContainer.leadingAnchor, constant: 20),
            firstTitleLabel.topAnchor.constraint(equalTo: firstCellContainer.topAnchor)
        ])
    }
    
    private func setupSecondCell() {
        secondCellContainer.backgroundColor = .white
        secondCellContainer.layer.cornerRadius = 10
        secondCellContainer.layer.masksToBounds = true
        secondCellContainer.layer.shadowColor = UIColor.black.cgColor
        secondCellContainer.layer.shadowOpacity = 0.1
        secondCellContainer.layer.borderColor = UIColor.gray.cgColor
        secondCellContainer.layer.borderWidth = 1
        secondCellContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        secondCellContainer.layer.shadowRadius = 5
        firstCellContainer.addSubview(secondCellContainer)
        
        let leftIcon = UIImageView()
        leftIcon.image = UIImage(systemName: "flag") // Replace with your desired icon
        leftIcon.tintColor = UIColor(hex: "#13A538")
        secondCellContainer.addSubview(leftIcon)
        
        secondTitleLabel.text = "AED"
        secondTitleLabel.font = UIFont.systemFont(ofSize: 20)
        secondTitleLabel.textColor = UIColor(hex: "#13A538")
        secondCellContainer.addSubview(secondTitleLabel)
        
        let conditionalImageView = UIImageView()
        conditionalImageView.image = UIImage(systemName: "star.fill") // Replace with desired image
        conditionalImageView.tintColor = .systemBlue
        conditionalImageView.isHidden = true // Make visible when condition is true
        secondCellContainer.addSubview(conditionalImageView)
        
        let verticalLine = UIView()
        verticalLine.backgroundColor = .lightGray
        verticalLine.isHidden = false // Show this line only when required
        secondCellContainer.addSubview(verticalLine)
        
        exchangeMoneyLabel.text = ""
        exchangeMoneyLabel.font = UIFont.systemFont(ofSize: 16)
        exchangeMoneyLabel.textColor = .black
        exchangeMoneyLabel.textAlignment = .right
        secondCellContainer.addSubview(exchangeMoneyLabel)
        
        secondCellContainer.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionalImageView.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        exchangeMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondCellContainer.leadingAnchor.constraint(equalTo: firstCellContainer.leadingAnchor, constant: 20),
            secondCellContainer.trailingAnchor.constraint(equalTo: firstCellContainer.trailingAnchor, constant: -20),
            secondCellContainer.topAnchor.constraint(equalTo: firstTitleLabel.bottomAnchor, constant: 10),
            secondCellContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // Constraints for left icon
            leftIcon.leadingAnchor.constraint(equalTo: secondCellContainer.leadingAnchor, constant: 10),
            leftIcon.centerYAnchor.constraint(equalTo: secondCellContainer.centerYAnchor),
            leftIcon.widthAnchor.constraint(equalToConstant: 24),
            leftIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Constraints for secondTitleLabel
            secondTitleLabel.leadingAnchor.constraint(equalTo: leftIcon.trailingAnchor, constant: 8),
            secondTitleLabel.centerYAnchor.constraint(equalTo: secondCellContainer.centerYAnchor),
            
            // Constraints for conditionalImageView
            conditionalImageView.leadingAnchor.constraint(equalTo: secondTitleLabel.trailingAnchor, constant: 8),
            conditionalImageView.centerYAnchor.constraint(equalTo: secondCellContainer.centerYAnchor),
            conditionalImageView.widthAnchor.constraint(equalToConstant: 24),
            conditionalImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Constraints for verticalLine
            verticalLine.leadingAnchor.constraint(equalTo: conditionalImageView.trailingAnchor, constant: 8),
            verticalLine.centerYAnchor.constraint(equalTo: secondCellContainer.centerYAnchor),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.heightAnchor.constraint(equalTo: secondCellContainer.heightAnchor, multiplier: 0.6),
            
            // Constraints for additionalLabel
            exchangeMoneyLabel.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 8),
            exchangeMoneyLabel.trailingAnchor.constraint(equalTo: secondCellContainer.trailingAnchor, constant: -10),
            exchangeMoneyLabel.centerYAnchor.constraint(equalTo: secondCellContainer.centerYAnchor)
        ])
    }
    
    private func setupThirdCell() {
        
        firstCellContainer.addSubview(thirdCellContainer)
        
        let bottomImageView = UIImageView()
        bottomImageView.image = UIImage(systemName: "arrow.clockwise.circle.fill") // Replace with desired image
        bottomImageView.tintColor = UIColor(hex: "#13A538")
        thirdCellContainer.addSubview(bottomImageView)
        
        let greyBackgroundLabel = UILabel()
        greyBackgroundLabel.text = "1 AED = 13.42 PHP"
        greyBackgroundLabel.textColor = .white
        greyBackgroundLabel.font = UIFont.systemFont(ofSize: 16)
        greyBackgroundLabel.backgroundColor = .gray
        greyBackgroundLabel.textAlignment = .center
        greyBackgroundLabel.layer.cornerRadius = 5
        greyBackgroundLabel.layer.masksToBounds = true
        thirdCellContainer.addSubview(greyBackgroundLabel)
        
        thirdCellContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        greyBackgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thirdCellContainer.leadingAnchor.constraint(equalTo: firstCellContainer.leadingAnchor, constant: 20),
            thirdCellContainer.trailingAnchor.constraint(equalTo: firstCellContainer.trailingAnchor, constant: -20),
            thirdCellContainer.topAnchor.constraint(equalTo: secondCellContainer.bottomAnchor, constant: 20), // Below the second container
            thirdCellContainer.heightAnchor.constraint(equalToConstant: 80), // Adjust height as needed
            
            // Constraints for bottomImageView
            bottomImageView.leadingAnchor.constraint(equalTo: thirdCellContainer.leadingAnchor, constant: 10),
            bottomImageView.centerYAnchor.constraint(equalTo: thirdCellContainer.centerYAnchor),
            bottomImageView.widthAnchor.constraint(equalToConstant: 40),
            bottomImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Constraints for greyBackgroundLabel
            greyBackgroundLabel.leadingAnchor.constraint(equalTo: bottomImageView.trailingAnchor, constant: 10),
            greyBackgroundLabel.trailingAnchor.constraint(equalTo: thirdCellContainer.trailingAnchor, constant: -10),
            greyBackgroundLabel.centerYAnchor.constraint(equalTo: thirdCellContainer.centerYAnchor),
            greyBackgroundLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTitleHeader() {
        // Create the title header label
        
        titleHeaderLabel.text = "Recipient Gets"  // Change this to whatever text you need
        titleHeaderLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleHeaderLabel.textColor = .black
        titleHeaderLabel.textAlignment = .left
        firstCellContainer.addSubview(titleHeaderLabel)
        
        titleHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Constraints for the title header label
            titleHeaderLabel.leadingAnchor.constraint(equalTo: firstCellContainer.leadingAnchor, constant: 20),
            titleHeaderLabel.topAnchor.constraint(equalTo: thirdCellContainer.bottomAnchor, constant: 10),
            titleHeaderLabel.trailingAnchor.constraint(equalTo: firstCellContainer.trailingAnchor, constant: -20),
            titleHeaderLabel.heightAnchor.constraint(equalToConstant: 40), // Adjust the height as needed
        ])
    }
    
    
    private func setupFourthCell() {
        let fourthCellContainer = UIView()
        fourthCellContainer.backgroundColor = .white
        fourthCellContainer.layer.cornerRadius = 10
        fourthCellContainer.layer.masksToBounds = true
        fourthCellContainer.layer.shadowColor = UIColor.black.cgColor
        fourthCellContainer.layer.shadowOpacity = 0.1
        fourthCellContainer.layer.borderColor = UIColor.gray.cgColor
        fourthCellContainer.layer.borderWidth = 1
        fourthCellContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        fourthCellContainer.layer.shadowRadius = 5
        firstCellContainer.addSubview(fourthCellContainer)
        
      
        countryIcon.image = UIImage(systemName: "flag") // Replace with your desired icon
        countryIcon.tintColor = UIColor(hex: "#13A538")
        fourthCellContainer.addSubview(countryIcon)
        
       
        countryCodeLabel.text = "Title 4"
        countryCodeLabel.font = UIFont.systemFont(ofSize: 20)
        countryCodeLabel.textAlignment = .center
        countryCodeLabel.textColor = UIColor(hex: "#13A538")
        fourthCellContainer.addSubview(countryCodeLabel)
        
        let conditionalImageView = UIImageView()
        conditionalImageView.image = UIImage(systemName: "arrow.down.circle.fill")
        conditionalImageView.contentMode = .scaleAspectFit  // Adjust image scaling if needed

        conditionalImageView.tintColor = .systemBlue
        conditionalImageView.isHidden = false // Make visible when condition is true
        fourthCellContainer.addSubview(conditionalImageView)
        
        let verticalLine = UIView()
        verticalLine.backgroundColor = .lightGray
        verticalLine.isHidden = false // Show this line only when required
        fourthCellContainer.addSubview(verticalLine)
        
        additionalLabel.text = "0"
        additionalLabel.font = UIFont.systemFont(ofSize: 16)
        additionalLabel.textColor = .darkGray
        additionalLabel.textAlignment = .right
        fourthCellContainer.addSubview(additionalLabel)
        
        fourthCellContainer.translatesAutoresizingMaskIntoConstraints = false
        countryIcon.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionalImageView.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fourthCellContainer.leadingAnchor.constraint(equalTo: firstCellContainer.leadingAnchor, constant: 20),
            fourthCellContainer.trailingAnchor.constraint(equalTo: firstCellContainer.trailingAnchor, constant: -20),
            fourthCellContainer.topAnchor.constraint(equalTo: titleHeaderLabel.bottomAnchor, constant: 20),
            fourthCellContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // Constraints for left icon
            countryIcon.leadingAnchor.constraint(equalTo: fourthCellContainer.leadingAnchor, constant: 10),
            countryIcon.centerYAnchor.constraint(equalTo: fourthCellContainer.centerYAnchor),
            countryIcon.widthAnchor.constraint(equalToConstant: 24),
            countryIcon.heightAnchor.constraint(equalToConstant: 24),
            
            // Constraints for titleLabel
            countryCodeLabel.leadingAnchor.constraint(equalTo: countryIcon.trailingAnchor, constant: 0),
            countryCodeLabel.centerYAnchor.constraint(equalTo: fourthCellContainer.centerYAnchor),
            
            // Constraints for conditionalImageView
            conditionalImageView.leadingAnchor.constraint(equalTo: countryCodeLabel.trailingAnchor, constant: 0),
            conditionalImageView.centerYAnchor.constraint(equalTo: fourthCellContainer.centerYAnchor),
            conditionalImageView.widthAnchor.constraint(equalToConstant: 24),
            conditionalImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Constraints for verticalLine
            verticalLine.leadingAnchor.constraint(equalTo: conditionalImageView.trailingAnchor, constant: 8),
            verticalLine.centerYAnchor.constraint(equalTo: fourthCellContainer.centerYAnchor),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.heightAnchor.constraint(equalTo: fourthCellContainer.heightAnchor, multiplier: 0.6),
            
            // Constraints for additionalLabel
            additionalLabel.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 8),
            additionalLabel.trailingAnchor.constraint(equalTo: fourthCellContainer.trailingAnchor, constant: -10),
            additionalLabel.centerYAnchor.constraint(equalTo: fourthCellContainer.centerYAnchor)
        ])
    }
}
