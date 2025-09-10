//
//  BookList.swift
//  Presentation
//
//  Created by Wonji Suh  on 9/8/25.
//


import Foundation
import Core
import DomainInterface

import ComposableArchitecture
import LogMacro

@Reducer
public struct BookList {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    public init() {}
    var book: [Book] = []
    // 현재 선택된 책의 인덱스 추가
    var selectedBookIndex: Int = 0
    // key: 책 고유키(아래 keyForBook 참고), value: 펼침여부
    var expandedSummary: [String: Bool] = [:]
    // 로딩 상태
    var isLoading: Bool = false
    // 에러 상태
    var errorMessage: String? = nil
    var url: String = ""

    // MARK: - Derived State (Computed Properties)
    
    // 현재 선택된 책
    var selectedBook: Book? {
      guard !book.isEmpty,
            selectedBookIndex >= 0,
            selectedBookIndex < book.count else { return nil }
      return book[selectedBookIndex]
    }
    
    // 현재 선택된 책의 요약 키를 반환 (Repository 사용을 위해 책 정보 직접 반환)
    var currentSummaryBookInfo: (title: String, author: String)? {
      guard let selectedBook = selectedBook else { return nil }
      return (selectedBook.title, selectedBook.author)
    }
    
    // 현재 선택된 책의 요약 펼침 상태
    var isCurrentSummaryExpanded: Bool {
      guard let bookInfo = currentSummaryBookInfo else { return false }
      let key = "SummaryExpanded.\(bookInfo.title)|\(bookInfo.author)"
      return expandedSummary[key] ?? false
    }
    
    // UI 표시를 위한 완전한 BookData
    var displayData: BookDisplayData? {
      guard let selectedBook = selectedBook else { return nil }
      return BookDisplayData(
        book: selectedBook,
        seriesNumber: selectedBookIndex + 1,
        totalSeries: book.count,
        isSummaryExpanded: isCurrentSummaryExpanded
      )
    }

    var currentSummaryKey: String? {
        guard let bookInfo = currentSummaryBookInfo else { return nil }
        return "SummaryExpanded.\(bookInfo.title)|\(bookInfo.author)"
      }
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case summaryToggleTapped(key: String)
    case seriesSelected(Int) // 시리즈 선택 액션 추가 (0-based index)
    case errorDismissed // 에러 상태 클리어 액션
    case tapUrl(url: String)
  }

  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case fetchBook
  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    case bookListResponse(Result<[Book], CustomError>)
    case summaryStateLoaded(key: String, isExpanded: Bool)
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
  }

  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .summaryToggleTapped(let key):
        let new = !(state.expandedSummary[key] ?? false)
        state.expandedSummary[key] = new
        
        // 키에서 책 정보 추출하여 Repository에 저장
        let components = key.replacingOccurrences(of: "SummaryExpanded.", with: "").split(separator: "|")
        if components.count == 2 {
          let title = String(components[0])
          let author = String(components[1])
          return .run { [summaryPersistenceRepository] _ in
            summaryPersistenceRepository.saveSummaryExpanded(new, for: title, author: author)
          }
        }
        return .none

      case .seriesSelected(let index):
        // 유효한 인덱스인지 확인
        guard index >= 0 && index < state.book.count else {
          #logDebug("잘못된 시리즈 인덱스", "index: \(index), total: \(state.book.count)")
          return .none
        }

        // 선택된 인덱스 업데이트
        state.selectedBookIndex = index
        #logDebug("시리즈 선택됨", "인덱스: \(index), 책: \(state.book[index].title)")
        return .none
        
      case .errorDismissed:
        // 에러 상태 클리어
        state.errorMessage = nil
        return .none

      case .tapUrl(let url):
        state.url = url
        return .none
    }
  }

  @Dependency(BookListUseCaseImpl.self) var bookListUseCase
  @Dependency(SummaryPersistenceUseCaseImpl.self) var summaryPersistenceRepository

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      case .fetchBook:
        state.isLoading = true
        return .run { send in
          let bookResult = await Result {
            try await bookListUseCase.getBookList()
          }

          switch bookResult {
            case .success(let bookResultData):
              await send(.inner(.bookListResponse(.success(bookResultData))))

            case .failure(let error):
              await send(.inner(.bookListResponse(.failure(.encodingError(error.localizedDescription)))))
          }
        }
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .bookListResponse(let result):
        state.isLoading = false
        switch result {
          case .success(let bookData):
            state.book = bookData
            state.errorMessage = nil  // 성공 시 에러 상태 클리어
            // 첫 번째 책을 기본 선택으로 설정
            state.selectedBookIndex = 0

            // 모든 책별 펼침 상태 로딩 (Repository 사용)
            return .run { [summaryPersistenceRepository] send in
              await withTaskGroup(of: Void.self) { group in
                for book in bookData {
                  group.addTask {
                    let isExpanded = summaryPersistenceRepository.loadSummaryExpanded(for: book.title, author: book.author)
                    let key = "SummaryExpanded.\(book.title)|\(book.author)"
                    await send(.inner(.summaryStateLoaded(key: key, isExpanded: isExpanded)))
                  }
                }
              }
            }

            #logDebug("책 목록 로딩 완료", "총 \(bookData.count)권, 기본 선택: \(bookData.first?.title ?? "없음")")

          case .failure(let error):
            #logDebug("데이터 로드 실패", error.localizedDescription)
            // 실패 시 에러 상태 설정
            state.errorMessage = "책 목록을 불러오는데 실패했습니다: \(error.localizedDescription)"
            // 실패 시 초기 상태로 리셋
            state.book = []
            state.selectedBookIndex = 0
            state.expandedSummary = [:]
        }
        return .none

      case .summaryStateLoaded(key: let key, isExpanded: let isExpanded):
        state.expandedSummary[key] = isExpanded
        #logDebug("요약 상태 로드 완료", "key: \(key), isExpanded: \(isExpanded)")
        return .none
    }
  }
}

enum SummaryPersistence {
  static func key(for title: String, author: String) -> String {
    "SummaryExpanded.\(title)|\(author)"
  }
  static func load(forKey key: String) -> Bool {
    UserDefaults.standard.bool(forKey: key)
  }
  static func save(_ value: Bool, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }
}
