//
//  FetchProductListRepository.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

protocol FetchProductListRepository {
    /// 커서 페이징 기반으로 상품 리스트를 가져옵니다
    /// - Parameter request: 커서 및 limit 정보
    /// - Returns: 페이징된 상품 리스트 응답
    func fetch(cursor: String?, pageCount: Int) async throws -> ProductListResult
}
