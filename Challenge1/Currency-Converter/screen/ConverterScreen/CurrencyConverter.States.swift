//
//  HomeViewStates.swift
//  Currency Converter
//
//  Created by ducvuong on 27/10/24.
//

import Foundation

enum CurrencyConverterStates: ViewStateProtocol {
    case ready
    case loading
    case finished
    case error(error: String)
    case empty
}

extension CurrencyConverterStates: Equatable {}
