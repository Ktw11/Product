//
//  DependencyContainer.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

final class DependencyContainer: ObservableObject, Sendable {
    
    // MARK: UseCase
    
    var fetchProductListUseCase: FetchProductListUseCase {
        FetchProductListUseCaseImpl(repository: fetchProductListRepository)
    }
    
    // MARK: Repository
    
    private var fetchProductListRepository: FetchProductListRepository {
        FetchProductListRepositoryMock()
    }
}
