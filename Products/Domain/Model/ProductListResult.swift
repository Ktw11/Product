//
//  ProductListResult.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

struct ProductListResult {
    let products: [Product] // product list
    let nextCursor: String? // 다음 페이지 커서 (마지막 페이지면 nil을 반환)
    let hasMore: Bool // 다음 페이지가 있는지 여부
    
    struct Product: Decodable, Identifiable {
        let id: String
        let name: String
        let price: Int
        let imageURLString: String
        let linkURLString: String
        let discountPrice: Int
        let discountRate: Int
        
        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case price
            case imageURLString = "image"
            case linkURLString = "link"
            case discountPrice
            case discountRate
        }
    }
}
