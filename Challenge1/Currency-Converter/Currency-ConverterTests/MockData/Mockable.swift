//
//  Mockable.swift
//  Currency Converter
//
//  Created by ducvuong on 28/10/24.
//

import Foundation
@testable import Currency_Converter

enum FileExtensionType: String {
    case json = ".json"
}

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJson<T: Decodable>(filename: String,
                                extensionType: FileExtensionType,
                                responseModel: T.Type) async -> Result<T, RequestError>  where T : Decodable
}

extension Mockable {
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
    
    func loadJson<T: Decodable>(filename: String,
                                extensionType: FileExtensionType,
                                responseModel: T.Type) async -> Result<T, RequestError> {
        guard let path = bundle.url(forResource: filename,
                                    withExtension: extensionType.rawValue) else {
            return .failure(.invalidURL)
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(.unknown)
        }
    }
}
