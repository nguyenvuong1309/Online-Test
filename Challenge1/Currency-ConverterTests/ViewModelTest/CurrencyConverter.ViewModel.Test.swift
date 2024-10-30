//
//  HomeViewModelTest.swift
//  Currency Converter
//
//  Created by ducvuong on 27/10/24.
//

import XCTest
import Combine
@testable import Currency_Converter

class CurrencyConverterViewModelTest: XCTestCase {
    private var homeViewModel: CurrencyConverterViewModel!
    private var cancellable: AnyCancellable?
    private var filename = "NewsResponse"
    private let isloadingExpectation = XCTestExpectation(description: "isLoading true")
    
    override func setUp() {
        super.setUp()
        
        homeViewModel = CurrencyConverterViewModel()
    }
    
    override func tearDown() {
        homeViewModel = nil 
        
        super.tearDown()
    }
    
     func test_ready_State() {
        let expectation = expectValue(of: homeViewModel.$states.eraseToAnyPublisher(),
                                      expectationDescription: "is state ready",
                                      equals: [{ $0 == .ready}])
        wait(for: [expectation.expectation], timeout: 1)
    }
    
      func test_empty_State() {
         let expectation = expectValue(of: homeViewModel.$states.eraseToAnyPublisher(),
                                       expectationDescription: "is state empty",
                                       equals: [{ $0 == .empty}])
         homeViewModel.changeStateToEmpty()
         wait(for: [expectation.expectation], timeout: 1)
     }
    
}
