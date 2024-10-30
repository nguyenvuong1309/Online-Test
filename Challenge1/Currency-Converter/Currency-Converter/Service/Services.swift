//
//  Services.swift
//  Currency Converter
//
//  Created by ducvuong on 28/10/24.
//

import Foundation
import SwiftUI

protocol NewsServiceable {
    func fetchExchangeRates() async -> Result<ExchangeRatesResponse, RequestError>
}

struct NewsService: HTTPClient, NewsServiceable {
    
    func fetchExchangeRates() async -> Result<ExchangeRatesResponse, RequestError> {
        return await sendRequest(endpoint: NewsEndpoint.exchangeRates, responseModel: ExchangeRatesResponse.self)
    }
}
