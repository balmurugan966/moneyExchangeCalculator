//
//  MoneyTransferViewModel.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 20/12/24.
//

import Foundation
import Combine

class MoneyTransferViewModel {
    private var exchangeRates: [ExchangeRate] = []
    private var countries: [Country] = []
    private var cancellables = Set<AnyCancellable>()
    private var networkService: MoneyExchangeService
    // Define a PassthroughSubject for error messages
        var exchangeRateErrorSubject = PassthroughSubject<String, Never>()
        
    @Published var countryList: [WelcomeElement] = []
    @Published var selectedCountry: WelcomeElement?
    @Published var exchangeRate: ExchangeRate?
    @Published var errorMessage: String?
    @Published var selectedDeliveryMethod: DeliveryMethod?

    init(networkService: MoneyExchangeService = MoneyExchangeService()) {
        self.networkService = networkService
    }

    // Fetch country list
    func fetchCountryList() {
        networkService.fetchCountryList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to load countries: \(error.localizedDescription)"
                    print("sds mass",self.errorMessage)
                }
            }, receiveValue: { countries in
                self.countryList = countries
                print("wdddsd",self.countryList.count)
            })
            .store(in: &cancellables)
    }

    // Fetch exchange rates for a specific country
    func fetchExchangeRates(for countryCode: String) {
        if let exchangeRate = networkService.fetchExchangeRate(for: countryCode) {
            self.exchangeRate = exchangeRate
            print("Currency Pair: \(exchangeRate.currencypair), Country Code: \(exchangeRate.countryCode), Exchange Rate: \(exchangeRate.exchangeRate)")
        } else {
            print("Exchange rate not found for the provided country code.")
            let message = "Exchange rate not found for the country code: \(countryCode). Please try again later."
            errorMessage = message
        }
    }
    
}
