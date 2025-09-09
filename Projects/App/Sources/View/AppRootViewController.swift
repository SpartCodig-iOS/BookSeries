//
//  AppRootViewController.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/8/25.
//

import UIKit
import Combine

import Shared
import Presentation

import ComposableArchitecture

@MainActor
 final class AppRootViewController: UIViewController {
  private let store: StoreOf<AppReducer>
  private let viewStore: ViewStoreOf<AppReducer>
  private var cancellables: Set<AnyCancellable> = []
  private var currentChild: UIViewController?

   init(store: StoreOf<AppReducer>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError() }

   override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    // 최초 반영 & 구독
    updateChild(for: viewStore.state)
    viewStore.publisher
      .removeDuplicates()
      .sink { [weak self] state in self?.updateChild(for: state) }
      .store(in: &cancellables)
  }

  private func updateChild(for state: AppReducer.State) {
    if let current = currentChild { remove(child: current) }
    let next = makeViewController(for: state)
    add(child: next)
    currentChild = next
  }

  private func makeViewController(for state: AppReducer.State) -> UIViewController {
    switch state {
    case .bookCoordinator:
      if let scoped = store.scope(
        state: \.bookCoordinator,
        action: \.view.bookCoordinator
      ) {
        return BookListCoordinatorViewController(appStore: scoped)
      } else {
        return FallbackViewController(title: "BookCoordinator store not found")
      }
    }
  }

  private func add(child: UIViewController) {
    addChild(child)
    child.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(child.view)
    NSLayoutConstraint.activate([
      child.view.topAnchor.constraint(equalTo: view.topAnchor),
      child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    child.didMove(toParent: self)
  }

  private func remove(child: UIViewController) {
    child.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
  }
}

