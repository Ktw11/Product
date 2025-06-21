//
//  FetchProductError.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

enum FetchProductError: Error {
    case unknown
    case invalidPageCount
    case networkError
}
