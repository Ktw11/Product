//
//  FetchProductListRepositoryMock.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

final class FetchProductListRepositoryMock: FetchProductListRepository {
    
    // MARK: Lifecycle
    
    init() {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else { fatalError() }

        do {
            let data = try Data(contentsOf: url)
            products = try JSONDecoder().decode([ProductListResult.Product].self, from: data)
        } catch {
            fatalError()
        }
    }
    
    // MARK: Properties
    
    private let products: [ProductListResult.Product]
    
    // MARK: Methods
    
    func fetch(cursor: String?, pageCount: Int) async throws -> ProductListResult {
        // 임의 delay
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let startIndex = findStartIndex(cursor: cursor)
        let endIndex = min(startIndex + pageCount, products.count)
        
        let pagedProducts = Array(products[startIndex..<endIndex])
        
        let hasMore: Bool = endIndex < products.count
        let nextCursor = hasMore ? products[endIndex - 1].id : nil
        
        return ProductListResult(
            products: pagedProducts,
            nextCursor: nextCursor,
            hasMore: hasMore
        )
    }
}

private extension FetchProductListRepositoryMock {
    func findStartIndex(cursor: String?) -> Int {
        guard let cursor = cursor else {
            // 첫 요청이니, 0을 리턴한다
            return 0
        }
        
        if let index = products.firstIndex(where: { $0.id == cursor }) {
            // 마지막으로 본 아이템의 다음 index를 리턴
            return index + 1
        } else {
            // 커서를 찾을 수 없으면 처음부터
            return 0
        }
    }
}
