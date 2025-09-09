//
//  AppReducer.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/8/25.
//

import ComposableArchitecture
import Presentation

// 2) AppReducer
@Reducer
struct AppReducer {

  @ObservableState
  @CasePathable
  enum State: Equatable {
    case bookCoordinator(BookListCoordinator.State)

    init() {
      self = .bookCoordinator(.init())
    }
  }

  enum Action: ViewAction {
    case view(View)
  }

  @CasePathable
  enum View {
    case bookCoordinator(BookListCoordinator.Action)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .view(viewAction):
        return handleViewAction(&state, action: viewAction)
      }
    }
    .ifCaseLet(\.bookCoordinator, action: \.view.bookCoordinator) {
      BookListCoordinator()
    }
  }

  func handleViewAction(
    _ state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {

    default:
      return .none
    }
  }
}
