//
//  Endpoints.swift
//  Currency Converter
//
//  Created by ducvuong on 28/10/24.
//

import Foundation
import SwiftUI

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return ""
    }
}


enum NewsEndpoint {
    case exchangeRates
}

extension NewsEndpoint: Endpoint {
    var queryItems: [URLQueryItem] {
        switch self {
        case .exchangeRates:
            return [URLQueryItem(name: "",value: "")]
        }
    }
    
    var query: String {
        switch self {
        case .exchangeRates:
            return ""
        }
    }

    var path: String {
            switch self {
            case .exchangeRates:
                return ""
            }
        }

    var method: RequestMethod {
        switch self {
        case .exchangeRates:
            return .get
        }
    }

    var header: [String : String]? {
        let accessToken = "120029318d94458c867a745671a02d09"
        
        switch self {
        case .exchangeRates:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .exchangeRates:
            return nil
        }
    }
}
