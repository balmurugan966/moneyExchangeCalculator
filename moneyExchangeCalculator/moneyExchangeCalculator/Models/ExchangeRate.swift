//
//  ExchangeRate.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 20/12/24.
//


import Foundation

// MARK: - Welcome
struct ExchangeRateResponse: Codable {
    let result: Result
}

// MARK: - Result
struct Result: Codable {
    let depositCountry, depositCurrency, depositCountryCode: String
    let data: [ExchangeRate]
    let responseStatus, responseMessage: String
}

// MARK: - Datum
struct ExchangeRate: Codable {
    let currencypair, countryCode, exchangeRate: String
}
