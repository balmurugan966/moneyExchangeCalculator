//
//  SelectDeliveryMethodViewController.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 20/12/24.
//

import UIKit
protocol SelectDeliveryMethodSelectionDelegate: AnyObject {
    func didSelectDeliveryMethod(_ selectedDeliveryMethod: DeliveryMethod)
}
class SelectDeliveryMethodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SelectDeliveryMethodSelectionDelegate?
    private let deliveryMethods: [DeliveryMethod]
    var didSelectDeliveryMethod: ((DeliveryMethod) -> Void)?
    // Track selected method
    private var selectedIndexPath: IndexPath?
    init(deliveryMethods: [DeliveryMethod]) {
        self.deliveryMethods = deliveryMethods
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundOverlay()
        setupHalfScreenView()
        setupCloseButton()
    }
    
    private func setupBackgroundOverlay() {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Background overlay with alpha
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHalfScreenView() {
        let halfScreenView = UIView()
        halfScreenView.backgroundColor = .white // No blur effect, just white background
        halfScreenView.layer.cornerRadius = 16
        halfScreenView.layer.masksToBounds = true
        halfScreenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(halfScreenView)
        
        NSLayoutConstraint.activate([
            halfScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            halfScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            halfScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            halfScreenView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        // Create a container view for table with padding
        let tableContainerView = UIView()
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        halfScreenView.addSubview(tableContainerView)
        
        // Table container constraints to apply padding
        NSLayoutConstraint.activate([
            tableContainerView.topAnchor.constraint(equalTo: halfScreenView.topAnchor),
            tableContainerView.leadingAnchor.constraint(equalTo: halfScreenView.leadingAnchor, constant: 20),
            tableContainerView.trailingAnchor.constraint(equalTo: halfScreenView.trailingAnchor, constant: -20),
            tableContainerView.bottomAnchor.constraint(equalTo: halfScreenView.bottomAnchor, constant: -50) // Add space for the close button
        ])
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DeliveryMethodCell.self, forCellReuseIdentifier: "DeliveryMethodCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white // Gray background for table view
        // Add space between cells (this can also be adjusted in heightForRowAt)
        tableView.separatorStyle = .none // Disable the default separator line
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Top & bottom padding
        tableContainerView.addSubview(tableView)
        
        // Table view constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor)
        ])
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        // Position close button below the table, with right 20 padding
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryMethodCell", for: indexPath) as! DeliveryMethodCell
        let deliveryMethod = deliveryMethods[indexPath.row]
        cell.deliveryMethod = deliveryMethod
        cell.backgroundColor = .white // Default background
        cell.selectionStyle = .none
        
        // Add gap between cells (Optional)
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.borderWidth = 1
        let method = deliveryMethods[indexPath.row]
        cell.deliveryMethod = method
        
        // Update the cell's selection state
        cell.isSelectedMethod = (selectedIndexPath == indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // You can handle the selected delivery method here
        let selectedMethod = deliveryMethods[indexPath.row]
        // Pass the selected country back to the delegate
        delegate?.didSelectDeliveryMethod(selectedMethod)
        
        // Get the selected country
        // Dismiss CountryTableViewController
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table View Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "Select Delivery Method"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.textColor = .black
        headerLabel.backgroundColor = .white
        headerLabel.textAlignment = .left
        headerLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Height of the header
    }
    
    
}
