//
//  BookListReducerTests.swift
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
struct BookListReducerTests {
  
  // MARK: - Test Data
  
  private let mockBooks = [
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
  
  // MARK: - State Tests
  
  @Test("초기 상태 테스트", .tags(.tcaReducerTest, .stateManagementTest, .unitTest))
  func testInitialState() {
    // Given
    let state = BookList.State()
    
    // Then
    #expect(state.book.isEmpty)
    #expect(state.selectedBookIndex == 0)
    #expect(state.expandedSummary.isEmpty)
    #expect(state.isLoading == false)
    #expect(state.errorMessage == nil)
    #expect(state.url == "")
  }
  
  @Test("선택된 책 계산 프로퍼티 테스트", .tags(.tcaReducerTest, .stateManagementTest, .unitTest))
  func testSelectedBookComputedProperty() {
    // Given
    var state = BookList.State()
    
    // When - 빈 상태
    #expect(state.selectedBook == nil)
    
    // When - 책이 있는 상태
    state.book = mockBooks
    state.selectedBookIndex = 0
    #expect(state.selectedBook?.title == "클린 코드")
    
    state.selectedBookIndex = 1
    #expect(state.selectedBook?.title == "이펙티브 자바")
    
    // When - 잘못된 인덱스
    state.selectedBookIndex = 999
    #expect(state.selectedBook == nil)
  }
  
  @Test("현재 요약 상태 테스트", .tags(.tcaReducerTest, .stateManagementTest, .unitTest))
  func testCurrentSummaryState() {
    // Given
    var state = BookList.State()
    state.book = mockBooks
    state.selectedBookIndex = 0
    
    // When - 기본 상태 (확장되지 않음)
    #expect(state.isCurrentSummaryExpanded == false)
    
    // When - 요약 확장
    let key = "SummaryExpanded.클린 코드|로버트 C. 마틴"
    state.expandedSummary[key] = true
    #expect(state.isCurrentSummaryExpanded == true)
  }
  
  // MARK: - View Action Tests
  
  @Test("요약 토글 액션 테스트", .tags(.tcaReducerTest, .viewActionTest, .actionTest))
  func testSummaryToggleAction() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    } withDependencies: {
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
    }
    
    // When
    let key = "SummaryExpanded.클린 코드|로버트 C. 마틴"
    await store.send(.view(.summaryToggleTapped(key: key))) {
      $0.expandedSummary[key] = true
    }
  }
  
  @Test("시리즈 선택 액션 테스트", .tags(.tcaReducerTest, .viewActionTest, .actionTest))
  func testSeriesSelectionAction() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    }



    // 책 데이터 설정
    await store.send(.inner(.bookListResponse(.success(mockBooks)))) {
      $0.book = mockBooks
      $0.selectedBookIndex = 0
      $0.isLoading = false
      $0.errorMessage = nil
    }

    store.exhaustivity = .off

    // When - 유효한 인덱스 선택
    await store.send(.view(.seriesSelected(1)))


  }
  
  @Test("에러 해제 액션 테스트", .tags(.tcaReducerTest, .viewActionTest, .errorHandlingTest))
  func testErrorDismissAction() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    }

    store.exhaustivity = .off
    // 에러 상태 설정
    await store.send(.inner(.bookListResponse(.failure(.encodingError("Test Error"))))) {
      $0.isLoading = false
//      $0.errorMessage = "책 목록을 불러오는데 실패했습니다: Test Error"
      $0.book = []
      $0.selectedBookIndex = 0
      $0.expandedSummary = [:]
    }
    store.exhaustivity = .on
    // When - 에러 해제
    await store.send(.view(.errorDismissed)) {
      $0.errorMessage = nil
    }
  }
  
  @Test("URL 탭 액션 테스트", .tags(.tcaReducerTest, .viewActionTest, .actionTest))
  func testTapUrlAction() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    }
    
    // When
    let testUrl = "https://example.com"
    await store.send(.view(.tapUrl(url: testUrl))) {
      $0.url = testUrl
    }

    await store.finish()
  }
  
  // MARK: - Async Action Tests
  
  @Test("책 목록 가져오기 성공 테스트", .tags(.tcaReducerTest, .asyncActionTest, .effectTest))
  func testFetchBookSuccess() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    } withDependencies: {
      $0.bookListUseCase = DefaultBookListRepositoryImpl()
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
    }


    
    // When
    await store.send(.async(.fetchBook)){
      $0.isLoading = true
    }

    // Then - 성공적으로 데이터가 로드됨을 확인하기 위해 상태 검증
    await store.skipReceivedActions()
    await store.finish()

    // 최종 상태 검증
    #expect(store.state.isLoading == false)
    #expect(store.state.book.count == 5) // DefaultBookListRepositoryImpl의 기본 책 개수
  }
  
  // MARK: - Inner Action Tests
  
  @Test("책 목록 응답 실패 처리 테스트", .tags(.tcaReducerTest, .innerActionTest, .errorHandlingTest))
  func testBookListResponseFailure() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    }
    store.exhaustivity = .off
    // When
    let error = CustomError.encodingError("Network Error")
    await store.send(.inner(.bookListResponse(.failure(error)))) {
      $0.isLoading = false
//      $0.errorMessage = "책 목록을 불러오는데 실패했습니다: Network Error"
      $0.book = []
      $0.selectedBookIndex = 0
      $0.expandedSummary = [:]
    }

  }
  
  @Test("요약 상태 로드 완료 테스트", .tags(.tcaReducerTest, .innerActionTest, .stateManagementTest))
  func testSummaryStateLoaded() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    }
    
    // When
    let key = "SummaryExpanded.테스트책|테스트작가"
    await store.send(.inner(.summaryStateLoaded(key: key, isExpanded: true))) {
      $0.expandedSummary[key] = true
    }
  }
  
  // MARK: - Integration Tests
  
  @Test("전체 플로우 통합 테스트", .tags(.tcaReducerTest, .integrationTest, .effectTest))
  func testFullFlowIntegration() async {
    // Given
    let store = TestStore(initialState: BookList.State()) {
      BookList()
    } withDependencies: {
      $0.bookListUseCase = DefaultBookListRepositoryImpl()
      $0.summaryPersistenceUseCase = DefaultSummaryPersistenceRepository()
    }
    

    store.exhaustivity = .off
    // When - 책 목록 가져오기
    await store.send(.async(.fetchBook))

    await store.skipReceivedActions()
    // 비동기 작업 완료 대기
    await store.finish()
    store.exhaustivity = .on

    // Then - 데이터가 로드됨
    #expect(store.state.isLoading == false)
    #expect(store.state.book.count == 5)
    
    // When - 시리즈 변경
    await store.send(.view(.seriesSelected(1))){
      $0.selectedBookIndex = 1
    }

    // When - 요약 토글
    let summaryKey = "SummaryExpanded.이펙티브 자바|조슈아 블로크"
    await store.send(.view(.summaryToggleTapped(key: summaryKey))){
      $0.expandedSummary[summaryKey] = true
    }
  }
  
  // MARK: - Edge Cases
  
  @Test("잘못된 시리즈 인덱스 처리 테스트", .tags(.tcaReducerTest, .errorHandlingTest, .unitTest))
  func testInvalidSeriesIndex() async {
    // Given
    var initialState = BookList.State()
    initialState.book = mockBooks
    
    let store = TestStore(initialState: initialState) {
      BookList()
    }
    
    // When - 음수 인덱스
    await store.send(.view(.seriesSelected(-1)))
    
    // When - 범위 초과 인덱스  
    await store.send(.view(.seriesSelected(999)))
    
    // Then - 상태가 변경되지 않음
    #expect(store.state.selectedBookIndex == 0)
  }
  
  @Test("빈 책 목록 상태 테스트", .tags(.tcaReducerTest, .stateManagementTest, .unitTest))
  func testEmptyBookListState() {
    // Given
    var state = BookList.State()
    
    // When
    state.book = []
    state.selectedBookIndex = 0
    
    // Then
    #expect(state.selectedBook == nil)
    #expect(state.currentSummaryBookInfo == nil)
    #expect(state.isCurrentSummaryExpanded == false)
    #expect(state.displayData == nil)
  }
}
