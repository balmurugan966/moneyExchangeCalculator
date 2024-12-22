//
//  WelcomeElement.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 22/12/24.
//

import Foundation

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let flags: Flags
    let name: Name
    let cca2, cioc: String
    let currencies: [String: Currency]
    let capital: [String]
    let languages: [String: String]
}

// MARK: - Currency
struct Currency: Codable {
    let name, symbol: String
}

// MARK: - Flags
struct Flags: Codable {
    let png: String
    let svg: String
    let alt: String
}

// MARK: - Name
struct Name: Codable {
    let common, official: String
    let nativeName: [String: NativeName]
}

// MARK: - NativeName
struct NativeName: Codable {
    let official, common: String
}

typealias Welcome = [WelcomeElement]

