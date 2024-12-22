//
//  CountryTableViewController.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit
protocol CountrySelectionDelegate: AnyObject {
    func didSelectCountry(_ country: WelcomeElement)
}

class CountryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var countries: [WelcomeElement] = [] // Your WelcomeElement data model
    var popularCountries: [WelcomeElement] = [] // Your popular WelcomeElement data model
    var filteredCountries: [WelcomeElement] = [] // Filtered countries based on search
    weak var delegate: CountrySelectionDelegate?  // Delegate property
    private var searchBar: UISearchBar!
    private var tableView: UITableView!
    private var collectionView: UICollectionView!
    private var overlayView: UIView!
    private var bottomView: UIView!
    private var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupBackgroundOverlay()
        setupBottomView()
        setupTitleLabel() // Add the title label setup
        setupSearchBar()
        setupCollectionView()
        setupTableView()
        setupPopularCountries() // Ensure popularCountries is set
    }
    private func setupTitleLabel() {
        // Create a container view to hold the title and close button
        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(titleContainer)
        
        // Title Label
        titleLabel = UILabel()
        titleLabel.text = "Explore Countries"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24) // Adjust font size and style
        titleLabel.textColor = .black // Adjust color as needed
        titleLabel.textAlignment = .left // Left-align the title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(titleLabel)
        
        // Close Button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.red, for: .normal) // Set the color to red
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16) // Adjust font size
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        titleContainer.addSubview(closeButton)
        
        // Constraints for the title container
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10), // Position below the overlay
            titleContainer.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            titleContainer.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            titleContainer.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Constraints for the title label
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor)
        ])
        
        // Constraints for the close button
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor)
        ])
    }

    // MARK: - Close Button Action

    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupPopularCountries() {
        popularCountries = getRandomCountries(from: countries, count: 10)
    }

    private func getRandomCountries(from countries: [WelcomeElement], count: Int) -> [WelcomeElement] {
        return Array(countries.shuffled().prefix(count))
    }

    // MARK: - Background Overlay
    
    private func setupBackgroundOverlay() {
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent black background
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        // Set the overlay view to cover the top half of the screen
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.centerYAnchor) // Bottom aligned to center
        ])
    }
    
    // MARK: - Bottom View with Rounded Corners
    
    private func setupBottomView() {
        bottomView = UIView()
        
        bottomView.backgroundColor = .white // No blur effect, just white background
        bottomView.layer.cornerRadius = 16
        bottomView.layer.masksToBounds = true
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        
        // Constraints for the bottom view
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Search Bar
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search Countries"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(searchBar)
        
        // Constraints for search bar
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10), // Position below the title
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Collection View for Popular Countries
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10 // Set horizontal space between cells
        layout.minimumLineSpacing = 10 // Set vertical space between cells
        layout.itemSize = CGSize(width: 100, height: 60) // Set item size
        layout.scrollDirection = .horizontal
        
        let collectionHeaderLabel = UILabel()
        collectionHeaderLabel.text = "Popular Countries"
        collectionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        collectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(collectionHeaderLabel)
        
        NSLayoutConstraint.activate([
            collectionHeaderLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15),
            collectionHeaderLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15),
        ])
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PopularCountryCell.self, forCellWithReuseIdentifier: "PopularCountryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        bottomView.addSubview(collectionView)
        
        // Constraints for collection view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: collectionHeaderLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    // MARK: - Table View for Country List
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        bottomView.addSubview(tableView)
        
        // Constraints for table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryTableViewCell
        
        let country = countries[indexPath.row]
        cell.country = country  // Pass the country object to the cell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "All Countries"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.textColor = .black
        headerLabel.textAlignment = .left
        headerLabel.backgroundColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
        ])
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Adjust the height as needed
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Get the selected country
           let selectedCountry = filteredCountries[indexPath.row]
           
           // Pass the selected country back to the delegate
           delegate?.didSelectCountry(selectedCountry)
           
           // Dismiss CountryTableViewController
           dismiss(animated: true, completion: nil)
       }
    
    // MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                // Access 'common' name from 'Name' object
                let commonName = $0.name.common.lowercased()
                return commonName.contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    // MARK: - CollectionView Delegate and DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCountryCell", for: indexPath) as! PopularCountryCell
        let country = popularCountries[indexPath.row]
        cell.configure(with: country.name.common, imageUrl: country.flags.png)
        return cell
    }
}

// MARK: - PopularCountryCell

class PopularCountryCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true // Ensures the image is clipped to the circle
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        // Add constraints for imageView and nameLabel
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Make the image view circular
        imageView.layer.cornerRadius = 15  // Half of the image size (30 / 2)
        
        // Add left-right padding for the cell
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String, imageUrl: String) {
        nameLabel.text = name
        
            imageView.loadImage(from: imageUrl)
    }
}


class CountryTableViewCell: UITableViewCell {
    
    var country: WelcomeElement? {
        didSet {
            configureCell()
        }
    }
    
    private let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15 // Half of the 30x30 size
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill // Ensures the image maintains aspect ratio
        return imageView
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(countryImageView)
        contentView.addSubview(countryLabel)
        
        NSLayoutConstraint.activate([
            // Set the size of the imageView to 30x30
            countryImageView.widthAnchor.constraint(equalToConstant: 30),
            countryImageView.heightAnchor.constraint(equalToConstant: 30),
            countryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            // Label constraints (you can adjust the position and padding as needed)
            countryLabel.leadingAnchor.constraint(equalTo: countryImageView.trailingAnchor, constant: 10),
            countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure the cell with country data
    private func configureCell() {
        guard let country = country else { return }
        countryLabel.text = country.name.common
        
        // Assuming the flag URL is available as a string in the country data
            countryImageView.loadImage(from: country.flags.png)
    }
}

