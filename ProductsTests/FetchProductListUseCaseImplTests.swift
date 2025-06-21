//
//  FetchProductListUseCaseImplTests.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation
import XCTest
@testable import Products

final class FetchProductListUseCaseImplTests: XCTestCase {
    
    private var mockRepository: MockFetchProductListRepository!
    private var sut: FetchProductListUseCaseImpl!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockFetchProductListRepository()
        sut = FetchProductListUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        
        super.tearDown()
    }
    
    // MARK: fetch
    
    func test_fetch_given_cursor_is_nil_pageCount_is_0_then_throw_FetchProductError_invalidPageCount() async throws {
        // given
        let givenCursor: String? = nil
        let givenPageCount: Int = 0
        
        do {
            // when
            _ = try await sut.fetch(cursor: givenCursor, pageCount: givenPageCount)
            XCTFail()
        } catch let error as FetchProductError {
            // then
            XCTAssertEqual(error, FetchProductError.invalidPageCount)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetch_given_cursor_is_nil_pageCount_is_negative_then_throw_FetchProductError_invalidPageCount() async throws {
        // given
        let givenCursor: String? = nil
        let givenPageCount: Int = -1
        
        do {
            // when
            _ = try await sut.fetch(cursor: givenCursor, pageCount: givenPageCount)
            XCTFail()
        } catch let error as FetchProductError {
            // then
            XCTAssertEqual(error, FetchProductError.invalidPageCount)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetch_given_cursor_and_pageCount_is_valid_when_repository_throws_FetchProductError_then_throw_same_FetchProductError() async throws {
        // given
        let givenCursor: String? = "test_cursor"
        let givenPageCount: Int = 10
        let givenError = FetchProductError.networkError
        
        mockRepository.expectedFetchError = givenError
        
        do {
            // when
            _ = try await sut.fetch(cursor: givenCursor, pageCount: givenPageCount)
            XCTFail()
        } catch let error as FetchProductError {
            // then
            XCTAssertEqual(error, FetchProductError.networkError)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetch_given_cursor_and_pageCount_is_valid_when_repository_throws_unknown_error_then_throw_FetchProductError_unknwon() async throws {
        // given
        let givenCursor: String? = "test_cursor"
        let givenPageCount: Int = 10
        
        mockRepository.expectedFetchError = NSError(domain: "", code: 1)
        
        do {
            // when
            _ = try await sut.fetch(cursor: givenCursor, pageCount: givenPageCount)
            XCTFail()
        } catch let error as FetchProductError {
            // then
            XCTAssertEqual(error, FetchProductError.unknown)
        } catch {
            XCTFail()
        }
    }
    
    func test_fetch_given_cursor_and_pageCount_is_valid_when_repository_returns_result_then_return_result() async throws {
        // given
        let givenCursor: String? = "test_cursor"
        let givenPageCount: Int = 10
        let givenResult: ProductListResult = .dummy()
        
        mockRepository.expectedFetchResult = givenResult
        
        do {
            // when
            let result = try await sut.fetch(cursor: givenCursor, pageCount: givenPageCount)
            
            // then
            XCTAssertEqual(result.products.count, givenResult.products.count)
            XCTAssertEqual(result.nextCursor, givenResult.nextCursor)
            XCTAssertEqual(result.hasMore, givenResult.hasMore)
            XCTAssertTrue(mockRepository.isFetchCalled)
            XCTAssertEqual(mockRepository.requestedFetchCursor, givenCursor)
            XCTAssertEqual(mockRepository.requestedFetchPageCount, givenPageCount)
        } catch {
            XCTFail()
        }
    }
}
