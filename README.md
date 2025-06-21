상품 리스트 및 상품 상세 화면을 구현하는 프로젝트입니다.


## 빌드 및 실행 방법
- XCode 16.0 이상
- iOS 15.0 이상 

위 조건 만족 시, 클론 후 따로 절차 없이 xcodeproj 실행으로 빌드 가능한 상태입니다.



## 외부 의존성
없음



## 아키텍처

[Clean Architecture]
프로젝트는 Clean Architecture 원칙을 따라 구성되어 있습니다:

Presentation: SwiftUI Views, ViewModels를 포함
Domain: Use Cases, Model(Entities), Interfaces를 포함
Data: Repository를 포함

[MVVM]
ViewModel에서 비즈니스 로직과의 통신을 하고, 결과가 View에 반영되도록 구현되었습니다.



## 주요 컴포넌트

[Domain]
`FetchProductListUseCase`: 상품 목록 조회 비즈니스 로직
`ProductListResult`: 상품 데이터 모델

[Presentation]
`ProductListView`: 상품 목록 화면
`ProductDetailView`: 상품 상세 화면
`PagingListViewModel`: 페이징 상태 관리

[Data]
- Repository 패턴으로 데이터 소스 추상화
- Mock 데이터를 사용하도록 구현된 상태



## 기술 스택

- UI Framework: SwiftUI
- 언어: Swift (minimum target iOS 15.0)
- 비동기 처리: async/await
- 의존성 주입: Custom Dependency Container + Environment
- 테스트: XCTest



## 특징

[페이징]
- 커서 기반 페이징으로 효율적인 데이터 로딩
- 중복 데이터 제거 로직
- 로딩 상태 및 에러 처리
