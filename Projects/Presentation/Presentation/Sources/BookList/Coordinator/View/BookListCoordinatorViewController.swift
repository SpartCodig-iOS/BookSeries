//
//  BookListCoordinatorViewController.swift
//  Presentation
//
//  Created by Wonji Suh  on 9/8/25.
//

import UIKit
import ComposableArchitecture
import Shared

@MainActor
public final class BookListCoordinatorViewController: UINavigationController, Coordinator {


  private let appStore: StoreOf<BookListCoordinator>
  private let listStore: StoreOf<BookList>

  public  init(appStore: StoreOf<BookListCoordinator>) {
    self.appStore = appStore
    self.listStore = Store(initialState: BookList.State()) { BookList()._printChanges() }
    super.init(nibName: nil, bundle: nil)
    setNavigationBarHidden(true, animated: false) // 네비 바 숨김
  }

  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  public override func viewDidLoad() {
    super.viewDidLoad()
    start()
  }

  // Coordinator 프로토콜이 nonisolated라면 @MainActor 붙이지 마세요.
  public func start() {
    let vc = BookListViewController(store: listStore)
    setViewControllers([vc], animated: false) // self가 내비게이션 컨트롤러
  }
}
