//
//  PagingState.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

struct PagingState<Item: Identifiable> {
    var items: [Item] = []
    var isFetching: Bool = false
    var isErrorOccurred: Bool = false
    var isLastPage: Bool = false
    var cursor: String?

    mutating func update(_ closure: (inout PagingState) -> Void) {
        closure(&self)
    }
}
