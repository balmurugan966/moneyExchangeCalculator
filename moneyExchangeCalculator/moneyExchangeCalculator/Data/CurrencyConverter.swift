//
//  CurrencyConverter.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 23/12/24.
//

import UIKit
class CurrencyConverter {
    
    // Function to convert from one currency to another using the exchange rate
       func convertCurrency(amount: Double, exchangeRate: ExchangeRate) -> Double? {
           // Convert exchangeRate from String to Double
           if let rate = Double(exchangeRate.exchangeRate) {
               // Perform the conversion if the exchange rate is valid
               let convertedAmount = amount * rate
               return convertedAmount
           } else {
               // Return nil if the conversion fails (e.g., invalid string)
               print("Invalid exchange rate")
               return nil
           }
       }
}
