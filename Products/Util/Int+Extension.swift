//
//  Int+Extension.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

extension Int {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: self)) ?? "\(self)")
    }
}
