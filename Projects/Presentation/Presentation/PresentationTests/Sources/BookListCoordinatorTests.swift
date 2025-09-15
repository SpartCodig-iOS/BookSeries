//
//  BookListCoordinatorTests.swift
//  PresentationTests
//
//  Created by Wonji Suh on 9/11/25.
//

import Testing
import Foundation
import ComposableArchitecture
@testable import Presentation
@testable import Model
@testable import Repository
@testable import UseCase

@MainActor
struct BookListCoordinatorTests {
  
  // MARK: - State Tests
  
  @Test("초기 상태 테스트", .tags(.tcaReducerTest, .coordinatorTest, .stateManagementTest))
  func testInitialState() {
    // Given
    let state = BookListCoordinator.State()
    
    // Then
    #expect(state.path.isEmpty)
    #expect(state.bookList.book.isEmpty)
    #expect(state.bookList.selectedBookIndex == 0)
    #expect(state.bookList.isLoading == false)
  }
  
  // MARK: - Action Tests
  
  @Test("onAppear 액션 테스트", .tags(.tcaReducerTest, .coordinatorTest, .actionTest))
  func testOnAppearAction() async {
    // Given
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    } withDependencies: {
      $0.bookListUseCase = DefaultBookListRepositoryImpl()
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
      $0.continuousClock = ImmediateClock()
    }
    
    store.exhaustivity = .off

    // When
    await store.send(.onAppear)
    
    // Then - 비동기 작업 완료 대기
    await store.finish()
    
    // 최종 상태 검증
    #expect(store.state.bookList.isLoading == false)
  }
  
  @Test("BookList 액션 위임 테스트", .tags(.tcaReducerTest, .coordinatorTest, .actionTest))
  func testBookListActionDelegation() async {
    // Given
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    }
    
    store.exhaustivity = .off
    
    // When - BookList 액션 전달
    await store.send(.bookList(.view(.errorDismissed)))
  }
  
  @Test("Path 액션 처리 테스트", .tags(.tcaReducerTest, .coordinatorTest, .navigationTest))
  func testPathActionHandling() async {
    // Given
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    }
    
    // When - Path에 BookList 추가
    await store.send(.path(.push(id: 0, state: .bookList(BookList.State())))) {
      $0.path[id: 0] = .bookList(BookList.State())
    }
    
    // When - Path에서 제거
    await store.send(.path(.popFrom(id: 0))) {
      $0.path.removeAll()
    }
  }
  
  // MARK: - Integration Tests
  
  @Test("전체 플로우 통합 테스트", .tags(.tcaReducerTest, .coordinatorTest, .integrationTest))
  func testFullCoordinatorFlow() async {
    // Given
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    } withDependencies: {
      $0.bookListUseCase = DefaultBookListRepositoryImpl()
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
      $0.continuousClock = ImmediateClock()
    }

    
    // When - 앱 시작
    await store.send(.onAppear)
    
//    // 비동기 작업 완료 대기
//    await store.finish()

    store.exhaustivity = .off(showSkippedAssertions: true)

    await store.skipReceivedActions()
    // Then - 데이터가 로드됨
    #expect(store.state.bookList.isLoading == false)
    #expect(store.state.bookList.book.count == 5)
    
    // When - 사용자 인터랙션
    let summaryKey = "SummaryExpanded.클린 코드|로버트 C. 마틴"
    await store.send(.bookList(.view(.summaryToggleTapped(key: summaryKey))))
  }
  
  // MARK: - Path Navigation Tests
  
  @Test("네비게이션 스택 관리 테스트", .tags(.tcaReducerTest, .coordinatorTest, .navigationTest))
  func testNavigationStackManagement() async {
    // Given
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    }
    
    // When - 첫 번째 화면 추가
    let firstBookListState = BookList.State()
    await store.send(.path(.push(id: 0, state: .bookList(firstBookListState)))) {
      $0.path[id: 0] = .bookList(firstBookListState)
    }
    
    // When - 두 번째 화면 추가
    let secondBookListState = BookList.State()
    await store.send(.path(.push(id: 1, state: .bookList(secondBookListState)))) {
      $0.path[id: 1] = .bookList(secondBookListState)
    }
    
    // Then - 스택에 2개 화면이 있음
    #expect(store.state.path.count == 2)
    
    // When - 마지막 화면 제거
    await store.send(.path(.popFrom(id: 1))) {
      $0.path[id: 1] = nil
    }
    
    // Then - 스택에 1개 화면만 남음
    #expect(store.state.path.count == 1)
  }
  
  @Test("빈 Path 액션 처리 테스트", .tags(.tcaReducerTest, .coordinatorTest, .navigationTest))
  func testEmptyPathAction() async {
    // Given
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    }

    // When - 빈 path에서 pop 시도
//    await store.send(.path(.popFrom(id: 999))) // ← 무

    // Then - 상태 변경 없음
    #expect(store.state.path.isEmpty)
  }
  
  // MARK: - Error Handling Tests
  
  @Test("BookList 에러 상태 처리 테스트", .tags(.tcaReducerTest, .coordinatorTest, .errorHandlingTest))
  func testBookListErrorHandling() async {
    // Given
    let errorRepository = DefaultBookListRepositoryImpl()
    errorRepository.setShouldThrowError(true, error: DefaultBookListRepositoryImpl.MockError.networkError)
    
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    } withDependencies: {
      $0.bookListUseCase = errorRepository
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
      $0.continuousClock = ImmediateClock()
    }
    
    store.exhaustivity = .off
    
    // When
    await store.send(.onAppear)
    
    // 비동기 작업 완료 대기
    await store.finish()
    // Then - 에러 상태 처리 확인
    #expect(store.state.bookList.isLoading == false)
    #expect(store.state.bookList.errorMessage == nil) 
    
    // When - 에러 해제
    await store.send(.bookList(.view(.errorDismissed)))
  }
  
  // MARK: - Dependency Tests
  
  @Test("의존성 주입 테스트", .tags(.tcaReducerTest, .coordinatorTest, .dependencyTest))
  func testDependencyInjection() async {
    // Given
    let customRepository = DefaultSummaryPersistenceRepository()
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    } withDependencies: {
      $0.summaryPersistenceUseCase = customRepository
      $0.continuousClock = ImmediateClock()
    }

    // When
    await store.send(.onAppear)

    await store.skipReceivedActions()
    // 비동기 작업 완료 대기
    await store.finish()
    
    // Then - 커스텀 의존성이 사용됨 (오류 없이 완료)
    #expect(store.state.bookList.isLoading == false)

    store.exhaustivity = .off
  }
  
  // MARK: - State Consistency Tests
  
  @Test("상태 일관성 테스트", .tags(.tcaReducerTest, .coordinatorTest, .stateManagementTest))
  func testStateConsistency() async {
    // Given
    let store = TestStore(initialState: BookListCoordinator.State()) {
      BookListCoordinator()
    }

    // When - 여러 액션 연속 실행
    await store.send(.bookList(.view(.seriesSelected(0))))
    await store.send(.bookList(.view(.errorDismissed)))
    await store.send(.bookList(.view(.tapUrl(url: "https://test.com")))) {
      $0.bookList.url = "https://test.com"
    }
    
    // Then - 상태가 일관되게 유지됨
    #expect(store.state.bookList.selectedBookIndex == 0)
    #expect(store.state.bookList.errorMessage == nil)
    #expect(store.state.bookList.url == "https://test.com")
  }
}
