//
//  CountryModel.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 20/12/24.
//

import Foundation

struct Country: Codable {
    let name: Name
    let languages: [String: String]
    let capital: String
    let flags: Flags
    let currencies: [String: Currency]
    let cca2: String
    let cioc: String
}
