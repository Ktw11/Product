//
//  PagingListViewModelTests.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation
import XCTest
@testable import Products

final class PagingListViewModelTests: XCTestCase {
    private var sut: PagingListViewModel<TestItem>!
    private var mockFetcher: PagingListViewModel<TestItem>.PageFetcher! = { _ in
        PagingFetchResult(items: [], isLastPage: false, nextCursor: nil)
    }
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = await PagingListViewModel<TestItem>(fetcher: mockFetcher)
    }
    
    override func tearDown() {
        sut = nil
        mockFetcher = nil
        
        super.tearDown()
    }
    
    // MARK: initialize
    
    func test_init_given_initialPage_then_sets_initial_state() async {
        // when
        sut = await PagingListViewModel<TestItem>(fetcher: mockFetcher)
        
        // then
        let state = await sut.state
        XCTAssertTrue(state.items.isEmpty)
        XCTAssertEqual(state.cursor, nil)
        XCTAssertFalse(state.isFetching)
        XCTAssertFalse(state.isErrorOccurred)
        XCTAssertFalse(state.isLastPage)
    }
    
    // MARK: fetchNextPage (success)
    
    func test_fetchNextPage_given_result_isLastPage_false_when_fetcher_success_then_updates_items_and_state_increment_currentPage_sets_isLastPage_false() async {
        // given
        let givenItems = [TestItem(id: "1"), TestItem(id: "2")]
        let givenLastPage: Bool = false
        let givenCursor: String = "cursor"
        let givenNextCursor: String = "cursor2"
        
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { cursor in
            return PagingFetchResult(items: givenItems, isLastPage: givenLastPage, nextCursor: givenNextCursor)
        }
        
        sut = await PagingListViewModel<TestItem>(fetcher: mockFetcher)
        
        // when
        let task = await sut.fetchNextPage()
        
        // then
        let result = try? await task?.value
        let state = await sut.state
        
        XCTAssertEqual(state.items, givenItems)
        XCTAssertEqual(state.cursor, givenNextCursor)
        XCTAssertFalse(state.isFetching)
        XCTAssertFalse(state.isErrorOccurred)
        XCTAssertEqual(state.isLastPage, givenLastPage)
    }
    
    func test_fetchNextPage_given_result_isLastPage_true_when_fethcer_success_then_updates_items_and_state_sets_cursor_to_nil_and_sets_isLastPage_true() async {
        // given
        let givenItems = [TestItem(id: "1"), TestItem(id: "2")]
        let givenLastPage: Bool = true
        let givenCursor: String = "cursor"
        let givenNextCursor: String? = nil
        
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { cursor in
            return PagingFetchResult(items: givenItems, isLastPage: givenLastPage, nextCursor: givenNextCursor)
        }
        
        sut = await PagingListViewModel<TestItem>(fetcher: mockFetcher)
        
        // when
        let task = await sut.fetchNextPage()
        
        // then
        let result = try? await task?.value
        let items = await sut.items
        let state = await sut.state
        
        XCTAssertEqual(items, givenItems)
        XCTAssertEqual(state.cursor, givenNextCursor)
        XCTAssertFalse(state.isFetching)
        XCTAssertFalse(state.isErrorOccurred)
        XCTAssertEqual(state.isLastPage, givenLastPage)
    }
    
    func test_fetchNextPage_given_result_isLastPage_false_when_first_and_second_fetch_success_then_appends_items_and_update_cursor() async {
        // given
        let givenFirstItems = [TestItem(id: "1"), TestItem(id: "2")]
        let givenSecondItems = [TestItem(id: "ㄱ"), TestItem(id: "ㄴ")]
        let nextCursor: String = "cursor2"
        let thirdCursor: String = "cursor3"
        
        var callCount = 0
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { cursor in
            callCount += 1
            if callCount == 1 {
                XCTAssertEqual(cursor, nil)
                return PagingFetchResult(items: givenFirstItems, isLastPage: false, nextCursor: nextCursor)
            } else {
                XCTAssertEqual(cursor, nextCursor)
                return PagingFetchResult(items: givenSecondItems, isLastPage: false, nextCursor: "cursor3")
            }
        }
        sut = await PagingListViewModel<TestItem>(fetcher: mockFetcher)
        await loadFirstPage()
        
        // when
        let task = await sut.fetchNextPage()
        
        // then
        _ = try? await task?.value
        
        let items = await sut.items
        let state = await sut.state
        
        XCTAssertEqual(items.count, (givenFirstItems + givenSecondItems).count)
        XCTAssertEqual(items, givenFirstItems + givenSecondItems)
        XCTAssertEqual(state.cursor, thirdCursor)
        XCTAssertFalse(state.isLastPage)
    }
    
    func test_fetchNextPage_given_result_isLastPage_true_when_first_and_second_fetch_success_then_appends_items_and_update_cursor() async {
        // given
        let givenFirstItems = [TestItem(id: "1"), TestItem(id: "2")]
        let givenSecondItems = [TestItem(id: "ㄱ"), TestItem(id: "ㄴ")]
        let nextCursor: String = "cursor2"
        
        var callCount = 0
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { cursor in
            callCount += 1
            if callCount == 1 {
                XCTAssertEqual(cursor, nil)
                return PagingFetchResult(items: givenFirstItems, isLastPage: false, nextCursor: nextCursor)
            } else {
                XCTAssertEqual(cursor, nextCursor)
                return PagingFetchResult(items: givenSecondItems, isLastPage: true, nextCursor: nil)
            }
        }
        
        sut = await PagingListViewModel<TestItem>(fetcher: mockFetcher)
        await loadFirstPage()
        
        // when
        let task = await sut.fetchNextPage()
        
        // then
        _ = try? await task?.value
        
        let items = await sut.items
        let state = await sut.state
        
        XCTAssertEqual(items.count, (givenFirstItems + givenSecondItems).count)
        XCTAssertEqual(items, givenFirstItems + givenSecondItems)
        XCTAssertEqual(state.cursor, nil)
        XCTAssertTrue(state.isLastPage)
    }

    // MARK: fetchNextPage (fail)
    
    func test_fetchNextPage_when_fetcher_throws_error_then_sets_state_isErrorOccurred_true_does_NOT_update_cursor() async {
        // given
        let expectedError = MockError.unknown
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { _ in
            throw expectedError
        }

        sut = await PagingListViewModel(fetcher: mockFetcher)
        
        // when
        let task = await sut.fetchNextPage()
        
        do {
            _ = try await task?.value
            XCTFail()
        } catch {
            // then
            let items = await sut.items
            let state = await sut.state
            XCTAssertTrue(items.isEmpty)
            XCTAssertTrue(state.isErrorOccurred)
            XCTAssertFalse(state.isFetching)
            XCTAssertEqual(state.cursor, nil)
        }
    }
    
    func test_fetchNextPage_when_error_occurs_after_successful_pages_then_keeps_existing_items_and_update_cursor_and_sets_isErrorOccurred_true() async {
        // given
        let givenFirstItems = [TestItem(id: "1"), TestItem(id: "2")]
        let givenCursor: String = "cursor1"
        
        var callCount = 0
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { _ in
            callCount += 1
            if callCount == 1 {
                return PagingFetchResult(items: givenFirstItems, isLastPage: false, nextCursor: givenCursor)
            } else {
                throw MockError.unknown
            }
        }
        
        await sut = PagingListViewModel(fetcher: mockFetcher)
        await loadFirstPage()
        
        let initialItems = await sut.items
        
        // when
        let task = await sut.fetchNextPage()
        
        do {
            _ = try await task?.value
            XCTFail()
        } catch {
            // then
            let items = await sut.items
            let state = await sut.state
            
            XCTAssertEqual(items, initialItems)
            XCTAssertTrue(state.isErrorOccurred)
            XCTAssertEqual(state.cursor, givenCursor)
        }
    }
    
    // MARK: fetchNextPage (cancel)
    
    func test_fetchNextPage_when_state_isFetching_true_then_returns_nil() async {
        // given
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            throw MockError.cancelled
        }
        
        sut = await PagingListViewModel(fetcher: mockFetcher)
        
        let firstTask = await sut.fetchNextPage()
        XCTAssertNotNil(firstTask)
        
        // when
        let secondTask = await sut.fetchNextPage()
        
        defer {
            firstTask?.cancel()
        }
        
        // then
        XCTAssertNil(secondTask)
    }
    
    func test_fetchNextPage_when_state_isLastPage_true_then_returns_nil() async {
        // given
        let givenFirstItems: [TestItem] = [.init(id: "1"), .init(id: "2")]
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { _ in
            return PagingFetchResult(items: givenFirstItems, isLastPage: true, nextCursor: nil)
        }
        
        sut = await PagingListViewModel(fetcher: mockFetcher)
        await loadFirstPage()
        
        // when
        let task = await sut.fetchNextPage()
        
        // then
        let items = await sut.items
        let state = await sut.state
        
        XCTAssertNil(task)
        XCTAssertEqual(items, givenFirstItems)
        XCTAssertTrue(state.isLastPage)
    }
    
    func test_fetchNextPage_when_cancelled_then_isFetching_remains_true() async {
        // given
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            throw MockError.cancelled
        }
        
        sut = await PagingListViewModel(fetcher: mockFetcher)
        
        let task = await sut.fetchNextPage()
        task?.cancel()
        
        let state = await sut.state
        XCTAssertTrue(state.isFetching)
    }
    
    // MARK: reset
    
    func test_reset_when_called_then_resets_to_initial_state() async {
        // given
        let givenFirstItems: [TestItem] = [.init(id: "1"), .init(id: "2")]
        let givenCursor: String = "cursor"
        
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { _ in
            return PagingFetchResult(items: givenFirstItems, isLastPage: false, nextCursor: givenCursor)
        }
        
        sut = await PagingListViewModel(fetcher: mockFetcher)
        await loadFirstPage()
        
        let itemsBeforeReset = await sut.items
        let stateBeforeReset = await sut.state
        
        XCTAssertEqual(itemsBeforeReset, givenFirstItems)
        XCTAssertEqual(stateBeforeReset.cursor, givenCursor)
        
        // when
        await sut.reset()
        
        // then
        let items = await sut.items
        let state = await sut.state
        XCTAssertTrue(items.isEmpty)
        XCTAssertEqual(state.cursor, nil)
        XCTAssertFalse(state.isFetching)
        XCTAssertFalse(state.isErrorOccurred)
        XCTAssertFalse(state.isLastPage)
    }
    
    func test_reset_when_fetchItems_is_ongoing_then_cancels_task() async {
        // given
        let mockFetcher: PagingListViewModel<TestItem>.PageFetcher = { _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            throw MockError.cancelled
        }
        
        sut = await PagingListViewModel(fetcher: mockFetcher)
        
        let task = await sut.fetchNextPage()
        XCTAssertNotNil(task)
        
        await sut.reset()
        
        do {
            _ = try await task?.value
            XCTFail()
        } catch is CancellationError {
            // then
            XCTAssert(true)
        } catch {
            XCTFail()
        }
    }
}

private extension PagingListViewModelTests {
    func loadFirstPage() async {
        let task = await sut.fetchNextPage()
        _ = try? await task?.value
    }
}


private struct TestItem: Identifiable, Equatable {
    let id: String
}
