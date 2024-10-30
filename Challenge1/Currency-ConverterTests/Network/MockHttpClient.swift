//
//  MockHttpClient.swift
//  Currency Converter
//
//  Created by ducvuong on 28/10/24.
//

import Foundation
@testable import Currency_Converter

final class MockHttpClient: NewsServiceable, Mockable {
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func fetchExchangeRates() async -> Result<Currency_Converter.ExchangeRatesResponse, Currency_Converter.RequestError> {
        return await loadJson(filename: filename,
                              extensionType: .json,
                              responseModel: Currency_Converter.ExchangeRatesResponse.self)
    }
}
