//
//  PagingFetchResult.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

struct PagingFetchResult<Item: Identifiable> {
    let items: [Item]
    let isLastPage: Bool
    let nextCursor: String?
}
