//
//  FetchProductListUseCaseImpl.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

struct FetchProductListUseCaseImpl: FetchProductListUseCase {
    
    // MARK: Lifecycle
    
    init(repository: FetchProductListRepository) {
        self.repository = repository
    }
    
    // MARK: Properties
    
    private let repository: FetchProductListRepository
    
    // MARK: Methods
    
    func fetch(cursor: String?, pageCount: Int) async throws -> ProductListResult {
        guard pageCount > 0 else { throw FetchProductError.invalidPageCount }
        
        do {
            return try await repository.fetch(cursor: cursor, pageCount: pageCount)
        } catch {
            throw convertToFetchProductError(error)
        }
    }
}

private extension FetchProductListUseCaseImpl {
    func convertToFetchProductError(_ error: Error) -> FetchProductError {
        guard let fetchProductError = error as? FetchProductError else {
            return FetchProductError.unknown
        }
        return fetchProductError
    }
}
