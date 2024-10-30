//
//  HttpClient.swift
//  Currency Converter
//
//  Created by ducvuong on 28/10/24.
//


import XCTest
@testable import Currency_Converter

class HttpClientTest: XCTestCase, Mockable, HTTPClient {
    var urlSession: URLSession!
    var endpoint: Endpoint!
    
    let mockString =
    """
        {
            "success": true,
            "timestamp": 1730047142,
            "base": "EUR",
            "date": "2024-10-27",
            "rates": {
                "USD": 1.078985,
                "VND": 25000
            }
        }
    """
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        urlSession = URLSession(configuration: config)
        endpoint = NewsEndpoint.exchangeRates
    }
    
    override func tearDown() {
        urlSession = nil
        endpoint = nil
        super.tearDown()
    }
    
    func test_Get_Data_Success() async throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        let response = HTTPURLResponse(url: urlComponents.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        Task {
            let result = await sendRequest(endpoint: endpoint,
                                           responseModel: ExchangeRatesResponse.self,
                                           urlSession: urlSession)
            switch result {
            case .success(let success):
                XCTAssertEqual(success.success,true)
                XCTAssertEqual(success.base, "EUR")
                expectation.fulfill()
            case .failure(let failure):
                XCTAssertThrowsError(failure)
            }
        }
        await fulfillment(of: [expectation], timeout: 2)
    }
    
    func test_News_BadResponse() {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        let response = HTTPURLResponse(url: urlComponents.url!,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        Task {
            let result = await sendRequest(endpoint: endpoint,
                                           responseModel: ExchangeRatesResponse.self,
                                           urlSession: urlSession)
            switch result {
            case .success(_):
                XCTAssertThrowsError("Fatal Error")
            case .failure(let failure):
                XCTAssertEqual(RequestError.unexpectedStatusCode, failure)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}