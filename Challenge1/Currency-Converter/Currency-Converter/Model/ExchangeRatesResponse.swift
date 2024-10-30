// // Model/ExchangeRatesResponse.swift
// import Foundation

struct ExchangeRatesResponse: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Double]
}

