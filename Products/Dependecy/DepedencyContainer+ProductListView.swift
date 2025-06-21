//
//  DepedencyContainer+ProductListView.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

extension DependencyContainer {
    @MainActor
    @ViewBuilder
    func buildProductListView() -> ProductListView {
        let useCase: FetchProductListUseCase = self.fetchProductListUseCase
        let viewModel = PagingListViewModel<ProductListResult.Product> { cursor in
            let result = try await useCase.fetch(cursor: cursor)
            return PagingFetchResult(items: result.products, isLastPage: !result.hasMore, nextCursor: result.nextCursor)
        }
        
        ProductListView(viewModel: viewModel)
    }
}
