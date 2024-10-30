//
//  Strings+Extensions.swift
//  Currency Converter
//
//  Created by ducvuong on 27/10/24.
//

import Foundation

extension String {
    func localised(using languageCode: String) -> String {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
