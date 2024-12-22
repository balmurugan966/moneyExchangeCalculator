//
//  MoneyExchangeService.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//

import Foundation
import Combine
// Models for Country and Exchange Rates
struct CountryResponse: Codable {
    let name: [String: String]
    let currencies: [String: [String]]
    let flags: [String: String]
    let cca2: String  // Country code
}

class MoneyExchangeService {
    
    private let baseURL = "https://restcountries.com/v3.1/independent" // Country API URL
    private var cancellables: Set<AnyCancellable> = []
    private let session: URLSession
    
    // Modify the initializer to accept a custom session for testing
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // Fetch Country List from API
    
    func fetchCountryList() -> AnyPublisher<[WelcomeElement], Error> {
        // Construct the URL with the required fields
        let url = URL(string: "\(baseURL)?fields=name,languages,capital,flags,currencies,cca2,cioc")!
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)  // Extract the data from the response
            .decode(type: [WelcomeElement].self, decoder: JSONDecoder())  // Decode the data into [WelcomeElement]
            .eraseToAnyPublisher()  // Return an AnyPublisher<[WelcomeElement], Error>
    }
    
    func fetchCountryData() {
        let urlString = "https://restcountries.com/v3.1/independent?fields=name,languages,capital,flags,currencies,cca2,cioc"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Print raw JSON to debug the response format
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            // Attempt to decode the data into [WelcomeElement]
            do {
                let countries = try JSONDecoder().decode([WelcomeElement].self, from: data)
                print("Decoded countries: \(countries)")
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchExchangeRatesFromFile() -> [ExchangeRate]? {
        // Locate the JSON file in the main bundle
        guard let url = Bundle.main.url(forResource: "ExchangeRateJson", withExtension: "json") else {
            print("Error: JSON file not found.")
            return nil
        }
        
        do {
            // Load the data from the file
            let data = try Data(contentsOf: url)
            
            // Decode the data into the ExchangeRateResponse model
            let decoder = JSONDecoder()
            let response = try decoder.decode(ExchangeRateResponse.self, from: data)
            
            // Return the data array inside the result
            return response.result.data
        } catch {
            print("Error loading or decoding JSON data: \(error)")
            return nil
        }
    }
        // Fetch a single exchange rate by country code
        func fetchExchangeRate(for countryCode: String) -> ExchangeRate? {
            guard let exchangeRates = fetchExchangeRatesFromFile() else {
                return nil
            }
            
            // Find the exchange rate matching the country code
            return exchangeRates.first { $0.countryCode == countryCode }
        }
}

