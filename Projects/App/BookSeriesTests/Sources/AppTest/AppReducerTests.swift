//
//  AppReducerTests.swift
//  BookSeriesTests
//
//  Created by Wonji Suh on 9/11/25.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import BookSeries
@testable import Presentation
@testable import Model
@testable import Repository
@testable import UseCase

@MainActor
struct AppReducerTests {
  
  // MARK: - State Tests
  
  @Test("초기 상태 테스트", .tags(.tcaReducerTest, .stateManagementTest, .unitTest))
  func testInitialState() {
    // Given
    let state = AppReducer.State()
    
    // Then
    switch state {
    case .bookCoordinator(let coordinatorState):
      #expect(coordinatorState.path.isEmpty)
      #expect(coordinatorState.bookList.book.isEmpty)
      #expect(coordinatorState.bookList.selectedBookIndex == 0)
      #expect(coordinatorState.bookList.isLoading == false)
    }
  }
  
  // MARK: - View Action Tests
  
  @Test("BookCoordinator 액션 위임 테스트", .tags(.tcaReducerTest, .actionTest, .viewActionTest))
  func testBookCoordinatorActionDelegation() async {
    // Given
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    } withDependencies: {
      $0.bookListUseCase = DefaultBookListRepositoryImpl()
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
      $0.continuousClock = ImmediateClock()
    }
    
    store.exhaustivity = .off
    
    // When - BookCoordinator onAppear 액션
    await store.send(.view(.bookCoordinator(.onAppear)))
    
    // 비동기 작업 완료 대기
    await store.finish()
    
    // Then - 최종 상태 검증
    switch store.state {
    case .bookCoordinator(let coordinatorState):
      #expect(coordinatorState.bookList.isLoading == false)
    }
  }
  
  @Test("BookList 액션 처리 테스트", .tags(.tcaReducerTest, .actionTest, .integrationTest))
  func testBookListActionHandling() async {
    // Given
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    }
    
    store.exhaustivity = .off
    
    // When - BookList 에러 해제 액션
    await store.send(.view(.bookCoordinator(.bookList(.view(.errorDismissed)))))
  }
  
  @Test("시리즈 선택 액션 테스트", .tags(.tcaReducerTest, .actionTest, .stateManagementTest))
  func testSeriesSelectionAction() async {
    // Given
    let mockBooks = [
      Book(
        title: "클린 코드",
        author: "로버트 C. 마틴",
        pages: 464,
        image: "clean_code.jpg",
        releaseDate: "2013-12-24",
        dedication: "프로그래밍 장인들에게",
        summary: "애자일 소프트웨어 장인 정신",
        wiki: "https://ko.wikipedia.org/wiki/클린_코드",
        chapters: ["깨끗한 코드", "의미 있는 이름", "함수"]
      ),
      Book(
        title: "이펙티브 자바",
        author: "조슈아 블로크",
        pages: 416,
        image: "effective_java.jpg",
        releaseDate: "2018-10-26",
        dedication: "자바 개발자들을 위하여",
        summary: "자바 플랫폼 모범 사례 78가지",
        wiki: "https://ko.wikipedia.org/wiki/이펙티브_자바",
        chapters: ["객체 생성과 파괴", "모든 객체의 공통 메서드"]
      )
    ]
    
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    }
    
    store.exhaustivity = .off
    
    // 먼저 책 데이터를 설정
    await store.send(.view(.bookCoordinator(.bookList(.inner(.bookListResponse(.success(mockBooks)))))))
    
    // When - 시리즈 선택
    await store.send(.view(.bookCoordinator(.bookList(.view(.seriesSelected(1))))))
  }
  
  // MARK: - Navigation Tests
  
  @Test("네비게이션 스택 처리 테스트", .tags(.tcaReducerTest, .navigationTest, .actionTest))
  func testNavigationStackHandling() async {
    // Given
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    }
    
    // When - Path에 새 화면 추가
    let newBookListState = BookList.State()
    await store.send(.view(.bookCoordinator(.path(.push(id: 0, state: .bookList(newBookListState)))))) {
      switch $0 {
      case .bookCoordinator(var coordinatorState):
        coordinatorState.path[id: 0] = .bookList(newBookListState)
        $0 = .bookCoordinator(coordinatorState)
      }
    }
    
    // When - Path에서 화면 제거
    await store.send(.view(.bookCoordinator(.path(.popFrom(id: 0))))) {
      switch $0 {
      case .bookCoordinator(var coordinatorState):
        coordinatorState.path[id: 0] = nil
        $0 = .bookCoordinator(coordinatorState)
      }
    }
  }
  
  // MARK: - Integration Tests
  
  @Test("전체 앱 플로우 통합 테스트", .tags(.tcaReducerTest, .integrationTest, .effectTest))
  func testFullAppFlowIntegration() async {
    // Given
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    } withDependencies: {
      $0.bookListUseCase = DefaultBookListRepositoryImpl()
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
      $0.continuousClock = ImmediateClock()
    }
    
    store.exhaustivity = .off
    
    // When - 앱 시작
    await store.send(.view(.bookCoordinator(.onAppear)))
    
    // 비동기 작업 완료 대기
    await store.finish()
    await store.skipReceivedActions()

    // Then - 데이터가 로드됨
    switch store.state {
    case .bookCoordinator(let coordinatorState):
      #expect(coordinatorState.bookList.isLoading == false)
      #expect(coordinatorState.bookList.book.count == 5)
    }
    
    // When - 사용자 인터랙션 (요약 토글)
    let key = "SummaryExpanded.클린 코드|로버트 C. 마틴"
    await store.send(.view(.bookCoordinator(.bookList(.view(.summaryToggleTapped(key: key))))))
  }
  
  // MARK: - Error Handling Tests
  
  @Test("에러 상태 처리 테스트", .tags(.tcaReducerTest, .errorHandlingTest, .actionTest))
  func testErrorStateHandling() async {
    // Given
    let errorRepository = DefaultBookListRepositoryImpl()
    errorRepository.setShouldThrowError(true, error: DefaultBookListRepositoryImpl.MockError.networkError)
    
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    } withDependencies: {
      $0.bookListUseCase = errorRepository
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
      $0.continuousClock = ImmediateClock()
    }
    
    store.exhaustivity = .off
    
    // When - 앱 시작 (에러 발생 예정)
    await store.send(.view(.bookCoordinator(.onAppear)))
    
    // 비동기 작업 완료 대기
    await store.finish()
    await store.skipReceivedActions()
    // Then - 에러 상태 확인
    switch store.state {
    case .bookCoordinator(let coordinatorState):
      #expect(coordinatorState.bookList.isLoading == false)
      #expect(coordinatorState.bookList.errorMessage == nil)
    }
    
    // When - 에러 해제
    await store.send(.view(.bookCoordinator(.bookList(.view(.errorDismissed)))))
  }
  
  // MARK: - State Transition Tests
  
  @Test("상태 전환 테스트", .tags(.tcaReducerTest, .stateManagementTest, .unitTest))
  func testStateTransitions() async {
    // Given
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    }
    
    // When - URL 설정
    await store.send(.view(.bookCoordinator(.bookList(.view(.tapUrl(url: "https://example.com")))))) {
      switch $0 {
      case .bookCoordinator(var coordinatorState):
        coordinatorState.bookList.url = "https://example.com"
        $0 = .bookCoordinator(coordinatorState)
      }
    }
    
    // Then - 상태가 올바르게 업데이트됨
    switch store.state {
    case .bookCoordinator(let coordinatorState):
      #expect(coordinatorState.bookList.url == "https://example.com")
    }
  }
  
  // MARK: - Default Action Handling Tests
  
  @Test("기본 액션 처리 테스트", .tags(.tcaReducerTest, .actionTest, .unitTest))
  func testDefaultActionHandling() async {
    // Given
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    }

    
    await store.send(.view(.bookCoordinator(.bookList(.view(.errorDismissed)))))
  }
  
  // MARK: - State Consistency Tests
  
  @Test("앱 상태 일관성 테스트", .tags(.tcaReducerTest, .stateManagementTest, .integrationTest))
  func testAppStateConsistency() async {
    // Given
    let store = TestStore(initialState: AppReducer.State()) {
      AppReducer()
    }
    
    // When - 연속된 액션들
    await store.send(.view(.bookCoordinator(.bookList(.view(.seriesSelected(0))))))
    await store.send(.view(.bookCoordinator(.bookList(.view(.tapUrl(url: "https://wiki.com")))))) {
      switch $0 {
      case .bookCoordinator(var coordinatorState):
        coordinatorState.bookList.url = "https://wiki.com"
        $0 = .bookCoordinator(coordinatorState)
      }
    }
    
    // Then - 상태 일관성 확인
    switch store.state {
    case .bookCoordinator(let coordinatorState):
      #expect(coordinatorState.bookList.selectedBookIndex == 0)
      #expect(coordinatorState.bookList.url == "https://wiki.com")
    }
  }
}
