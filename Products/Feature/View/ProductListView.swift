//
//  ProductListView.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

struct ProductListView: View {
    
    // MARK: Lifecycle
    
    init(viewModel: PagingListViewModel<ProductListResult.Product>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Properties
    
    @StateObject var viewModel: PagingListViewModel<ProductListResult.Product>
    
    var body: some View {
        contentView(items: viewModel.items, isErrorOccurred: viewModel.isErrorOccurred)
            .onAppear {
                viewModel.fetchNextPage()
            }
    }
}

private extension ProductListView {
    var productListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.items, id: \.id) { item in
                    ProductListCell(product: item)
                        .onAppear {
                            if viewModel.items.last?.id == item.id && !viewModel.isLastPage {
                                viewModel.fetchNextPage()
                            }
                        }
                }
                
                if !viewModel.isLastPage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .hideScrollIndicator()
    }
    
    var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            
            Text("상품 불러오는 중...")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 25))
                .foregroundColor(.red)
            
            VStack(spacing: 8) {
                Text("상품을 불러올 수 없습니다")
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
            }
            
            Button("다시 시도") {
                viewModel.reset()
                viewModel.fetchNextPage()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func contentView(items: [ProductListResult.Product], isErrorOccurred: Bool) -> some View {
        if !items.isEmpty {
            productListView
        } else if isErrorOccurred {
            errorView
        } else {
            loadingView
        }
    }
}

private struct ProductListCell: View {
    
    // MARK: Properties
    
    let product: ProductListResult.Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.imageURLString)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                PriceView(
                    price: product.price,
                    discountInfo: .init(
                        discountPrice: product.discountPrice,
                        discountRate: product.discountRate
                    )
                )
            }
            
            Spacer(minLength: 12)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ProductListView(viewModel: PagingListViewModel<ProductListResult.Product>() { _ in
        return .init(items: [], isLastPage: false, nextCursor: nil)
    })
}
