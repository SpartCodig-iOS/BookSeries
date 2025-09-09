//
//  BookListCoordinator.swift
//  Presentation
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation

import ComposableArchitecture


@Reducer
public struct BookListCoordinator {
  public init() {}


  @ObservableState
  public struct State: Equatable {
    var path: StackState<Path.State> = .init()
    var bookList = BookList.State()
    public init() {}
  }

  public enum Action {
    case onAppear
    case path(StackActionOf<Path>)
    case bookList(BookList.Action)

  }

  @Dependency(\.continuousClock) var clock

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .onAppear:
        return .concatenate(
          .run {
            await $0(.bookList(.async(.fetchBook)))
          }

        )

        case let .path(action):
          return handlePathAction(state: &state, action: (action))

        case .bookList:
          return .none
        }
      }
    .forEach(\.path, action: \.path)
    Scope(state: \.bookList, action: \.bookList) {
      BookList()
    }
  }

  private func handlePathAction(
    state: inout State,
    action: StackActionOf<Path>
  ) -> Effect<Action> {
    switch action {
      default:
        return .none
    }
  }
}

extension BookListCoordinator {
  @Reducer(state: .equatable)
  public enum Path {
    case bookList(BookList)
  }
}

