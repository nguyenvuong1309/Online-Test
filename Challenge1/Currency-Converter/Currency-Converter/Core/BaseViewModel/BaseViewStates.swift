//
//  BaseViewStates.swift
//  Currency Converter
//
//  Created by ducvuong on 27/10/24.
//

import Foundation
 
protocol ViewStateProtocol {
    static var ready: Self { get }
}

protocol ViewStatable {
    associatedtype ViewState: ViewStatable = DefaultViewState
}

enum DefaultViewState: ViewStateProtocol {
    case ready
}
