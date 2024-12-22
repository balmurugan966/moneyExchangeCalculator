//
//  MoneyTransferViewController.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 20/12/24.
//

import UIKit
import Combine

class MoneyTransferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CountrySelectionDelegate, SelectDeliveryMethodSelectionDelegate {
    
    func didSelectDeliveryMethod(_ selectedDeliveryMethod: DeliveryMethod) {
        viewModel.selectedDeliveryMethod = selectedDeliveryMethod
        tableView.reloadData()
    }
    
    private var viewModel: MoneyTransferViewModel
    private var cancellables = Set<AnyCancellable>()
    private var blurEffectView: UIVisualEffectView?
    
    // Delivery Methods List
    let deliveryMethods: [DeliveryMethod] = [
        DeliveryMethod(name: "Bank Account", fee: 0, estimatedTime: "1-3 Business Days", imageName: "building.columns"),
        DeliveryMethod(name: "Cash Pickup", fee: 5.99, estimatedTime: "Within 1-2 Days", imageName: "dollarsign.circle"),
        DeliveryMethod(name: "Mobile Wallet", fee: 3.99, estimatedTime: "Instant", imageName: "creditcard.fill"),
    ]
    
    // Table View
    var tableView: UITableView!
    
    // This init is for programmatically created view controllers
    init(viewModel: MoneyTransferViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // This init is for view controllers loaded from a storyboard
    required init?(coder: NSCoder) {
        // Instantiate the view model here if it's coming from the storyboard
        let defaultViewModel = MoneyTransferViewModel()
        self.viewModel = defaultViewModel
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchCountryList()
    }
    
    @objc func didTapQuestionMark() {
        // Handle the question mark button tap here
        print("Question mark button tapped!")
    }
    
    
    private func setupUI() {
        // Set the navigation title
        navigationItem.title = "Money Transfer" // Change this to your desired title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white // Change this to your preferred color
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        // Create a right bar button item with a question mark SF Symbol
        let questionMarkButton = UIBarButtonItem(
            image: UIImage(systemName: "questionmark.circle"), // SF Symbol for question mark
            style: .plain,
            target: self,
            action: #selector(didTapQuestionMark)
        )
        questionMarkButton.tintColor = .white
        navigationItem.rightBarButtonItem = questionMarkButton
        
        view.backgroundColor = UIColor(hex: "#13A538")
        
        // Setup TableView
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80 // Estimated height to improve performance
        tableView.register(DropDownTableViewCell.self, forCellReuseIdentifier: "DropDownTableViewCell")
        tableView.register(ExchangeRateTableViewCell.self, forCellReuseIdentifier: "ExchangeRateTableViewCell")
        tableView.backgroundColor = UIColor(hex: "#13A538")
        view.addSubview(tableView)
        
        // Apply constraints directly to the tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Left padding
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Right padding
        ])
    }
    
    private func bindViewModel() {
        viewModel.$countryList
            .receive(on: RunLoop.main)
            .sink { [weak self] countries in
                // Reload table view when country list changes
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedCountry
            .receive(on: RunLoop.main)
            .sink { [weak self] country in
                guard let country = country else { return }
                self?.tableView.reloadData()
                self?.viewModel.fetchExchangeRates(for: country.cioc)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$exchangeRate
            .receive(on: RunLoop.main)
            .sink { [weak self] exchangeRate in
                if let exchangeRate = exchangeRate {
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    func didSelectCountry(_ country: WelcomeElement) {
        // Pass the selected country to the viewModel
        viewModel.selectedCountry = country
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Table View Data Source and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // One for countries, one for delivery methods
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 // Number of countries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
            cell.firstTitleLabel.text = "Country"
            cell.selectionStyle = .none
            cell.countryDetails = viewModel.selectedCountry
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
            cell.selectionStyle = .none
            cell.firstTitleLabel.text = "Delivery Method"
            cell.deliveryMethodDetails = viewModel.selectedDeliveryMethod
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRateTableViewCell", for: indexPath) as! ExchangeRateTableViewCell
            cell.selectionStyle = .none
            cell.firstTitleLabel.text = "Delivery Method"
            cell.exchangeMoneyLabel.text = "1000.00"
            cell.countryDetails = viewModel.selectedCountry
            cell.countryCodeLabel.text = viewModel.exchangeRate?.countryCode ?? "IND"
            let converter = CurrencyConverter()
            
            let aedAmount: Double = 1000 // Amount in AED
            
            // Assuming your viewModel.exchangeRate contains an ExchangeRate object or a string to be converted
            
            // Define the ExchangeRate object properly before calling the convertCurrency method
            if let exchangeRate = viewModel.exchangeRate {
                // Convert the amount from AED to INR
                let inrAmount = converter.convertCurrency(amount: aedAmount, exchangeRate: exchangeRate)
                
                // Set the labels with the appropriate values
                cell.additionalLabel.text = String(inrAmount ?? 0) // You don't need to wrap `inrAmount` in `String()` because it's already a string
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
            cell.selectionStyle = .none
            cell.firstTitleLabel.text = "Expected Payment"
            cell.secondTitleLabel.text = "Selected Payment Method"
            return cell
        }
    }
    
    // Add Gap Between Sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 // Adjust this value for the gap between sections
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(hex: "#13A538") // Make it transparent
        return headerView
    }
    // Add this UITableViewDelegate method to adjust the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 400
        } else {
            return 120
        }
        // Height for the delivery method cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Country selected, notify delegate
            let countryTableViewController = CountryTableViewController()
            countryTableViewController.countries = viewModel.countryList
            countryTableViewController.popularCountries = viewModel.countryList
            countryTableViewController.delegate = self
            countryTableViewController.modalPresentationStyle = .overFullScreen
            countryTableViewController.filteredCountries = viewModel.countryList
            present(countryTableViewController, animated: true)
        }  else if indexPath.section == 1 {
            // Present the modal for selecting delivery methods
            let deliveryMethodVC = SelectDeliveryMethodViewController(deliveryMethods: deliveryMethods)
            deliveryMethodVC.modalPresentationStyle = .overFullScreen // Important for overlay to work
            deliveryMethodVC.delegate = self
            present(deliveryMethodVC, animated: true)
        }
    }
}
