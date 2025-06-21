//
//  MockFetchProductListRepository.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation
@testable import Products

final class MockFetchProductListRepository: @unchecked Sendable, FetchProductListRepository {
    
    private(set) var isFetchCalled: Bool = false
    private(set) var requestedFetchCursor: String?
    private(set) var requestedFetchPageCount: Int?
    var expectedFetchResult: ProductListResult?
    var expectedFetchError: Error?
    
    func fetch(cursor: String?, pageCount: Int) async throws -> ProductListResult {
        isFetchCalled = true
        requestedFetchCursor = cursor
        requestedFetchPageCount = pageCount
        
        if let expectedFetchResult {
            return expectedFetchResult
        } else if let expectedFetchError {
            throw expectedFetchError
        } else {
            throw MockError.notImplemented
        }
    }
}
