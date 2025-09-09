//
//  BookListViewController.swift
//  Presentation
//
//  Created by Wonji Suh  on 9/5/25.
//

import UIKit
import Core
import ComposableArchitecture
import Shared

public final class BookListViewController: BaseViewController<BookListView, BookList> {

  public init(store: StoreOf<BookList>) {
    super.init(rootView: BookListView(), store: store)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  public override func setupView() {
    super.setupView()
    view.backgroundColor = .white
    navigationItem.title = "Book List"
  }

  public override func configureUI() {
    super.configureUI()
    store.send(.async(.fetchBook))
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    bindState()
  }

  public override func bindState() {
    super.bindState()
    viewStore.publisher
      .map(\.book)
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] books in
        guard let self = self else { return }
        guard let first = books.first,
              let index = books.firstIndex(of: first) else {
          self.rootView.setTitle("No Book")
          self.rootView.setSeriesNumber(0, total: books.count)
          return
        }
        self.rootView
          .configure(
            title: first.title,
            author: first.author,
            releasedDate: first.releaseDate,
            pages: first.pages,
            seriesNumber: index + 1,
            image: first.image
          )
      }
      .store(in: &cancellables)
  }
}
