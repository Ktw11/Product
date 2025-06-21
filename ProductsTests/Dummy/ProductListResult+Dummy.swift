//
//  ProductListResult+Dummy.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation
@testable import Products

extension ProductListResult {
    static func dummy(
        products: [Product]? = nil,
        nextCursor: String? = nil,
        hasMore: Bool? = nil
    ) -> ProductListResult {
        .init(
            products: products ?? [
                .init(
                    id: "id",
                    name: "name",
                    price: 123,
                    imageURLString: "www.test.com",
                    linkURLString: "www.test.com",
                    discountPrice: 120,
                    discountRate: 20
                )
            ],
            nextCursor: nextCursor,
            hasMore: hasMore ?? true
        )
    }
}
