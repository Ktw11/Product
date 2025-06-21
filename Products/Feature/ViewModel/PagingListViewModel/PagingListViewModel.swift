//
//  PagingListViewModel.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import Foundation

@MainActor
final class PagingListViewModel<Item: Identifiable>: ObservableObject {
    
    // MARK: Lifecycle
    
    init(fetcher: @escaping PageFetcher) {
        self.fetcher = fetcher
    }
    
    // MARK: Properties
    
    @Published private(set) var state: PagingState<Item> = .init()
    
    typealias PageFetcher = (_ cursor: String?) async throws -> PagingFetchResult<Item>
    
    private let fetcher: PageFetcher
    private var fetchingTask: Task<PagingFetchResult<Item>, Error>?
    
    // MARK: Methods
    
    @discardableResult
    func fetchNextPage() -> Task<PagingFetchResult<Item>, Error>? {
        guard !state.isFetching, !state.isLastPage else { return nil }
        
        state.update {
            $0.isFetching = true
            $0.isErrorOccurred = false
        }

        fetchingTask = Task { [weak self, cursor = self.state.cursor, fetcher] in
            defer {
                // reset에 의해 Task가 cancel 될 수 있다.
                // 이 때 state도 같이 초기화되는데,
                // 아래의 코드는 비동기로 호출되어 타이밍 이슈를 유발할 수 있다.
                //. ex.
                //   1. cancel 요청 받음
                //   2. 새로운 Task가 생성되어 isFetching이 true로 set.
                //   3. 비동기로 1번에서 요청된 cancel에 의해 아래 코드(state.isFetching = false) 호출
                // -> 실제론 isFetching이 true이어야 하나, false로 설정되는 상황 발생
                // 위 시나리오를 막기위해 Cancel로 인해 Task가 종료되는 경우엔 isFetching을 변경하지 않는다
                // (reset에 의해 false로 바뀔것)
                if !Task.isCancelled {
                    self?.state.isFetching = false
                }
            }
            
            do {
                try Task.checkCancellation()
                
                let result = try await fetcher(cursor)

                try Task.checkCancellation()

                self?.updateState(from: result)
                
                return result
            } catch let cancellationError as CancellationError {
                throw cancellationError
            } catch {
                self?.state.isErrorOccurred = true
                throw error
            }
        }
        
        return fetchingTask
    }
    
    func reset() {
        fetchingTask?.cancel()
        state = PagingState()
    }
}

extension PagingListViewModel {
    var items: [Item] {
        state.items
    }
    
    var isErrorOccurred: Bool {
        state.isErrorOccurred
    }
    
    var isLastPage: Bool {
        state.isLastPage
    }
}

private extension PagingListViewModel {
    func updateState(from result: PagingFetchResult<Item>) {
        state.update {
            $0.isLastPage = result.isLastPage
            $0.cursor = result.nextCursor
            $0.items.append(contentsOf: result.items)
        }
    }
}
