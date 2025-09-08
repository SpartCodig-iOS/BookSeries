//
//  BookList.swift
//  Presentation
//
//  Created by Wonji Suh  on 9/8/25.
//


import Foundation
import Core

import ComposableArchitecture
import LogMacro

@Reducer
public struct BookList {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    public init() {}
    var book: [Book] = []

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

  }



  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case fetchBook
  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    case bookListResponse(Result<[Book], CustomError>)
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

    }
  }

  @Dependency(BookListUseCaseImpl.self) var bookListUseCase

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      case .fetchBook:
        return .run { send in
          let bookResult =  await Result {
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
        switch result {
          case .success(let bookData):
            state.book = bookData
            #logDebug("book 데이터", bookData)

          case .failure(let error):
            #logDebug("데이터 로드 실패", error.localizedDescription)
        }
        return .none

    }
  }
}

