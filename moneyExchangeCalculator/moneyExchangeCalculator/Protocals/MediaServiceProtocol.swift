//
//  MediaServiceProtocol.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import Combine

protocol MediaServiceProtocol {
    func fetchCountryList() -> AnyPublisher<[Country], Error>
}

