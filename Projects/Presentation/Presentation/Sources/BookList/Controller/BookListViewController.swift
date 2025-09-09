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
import Combine

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
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    store.send(.async(.fetchBook))
    bindState()
  }

  public override func bindActions() {
    super.bindActions()


  }


  public override func bindState() {
    super.bindState()

    // 1) 책 콘텐츠 렌더 (단순)
    viewStore.publisher
      .map(\.book)
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] books in
        guard let self = self else { return }
        guard let first = books.first,
              let idx = books.firstIndex(of: first) else {
          self.rootView.setTitle("No Book")
          self.rootView.setSeriesNumber(0, total: books.count)
          return
        }

        self.rootView.configure(
          title: first.title,
          author: first.author,
          releasedDate: first.releaseDate,
          pages: first.pages,
          seriesNumber: idx + 1,
          image: first.image,
          dedication: first.dedication,
          summary: first.summary,
          chapters: first.chapters
        )

        // 초깃값 반영(펼침상태)
        let key = SummaryPersistence.key(for: first.title, author: first.author)
        let expanded = self.viewStore.expandedSummary[key] ?? false
        self.rootView.applySummaryExpanded(expanded, fullText: first.summary)
      }
      .store(in: &cancellables)

    // 2) 펼침여부 변경 (딕셔너리 전체 비교 대신 "필요한 값"만 뽑아서 비교)
    let summaryPublisher = viewStore.publisher
      .map { state -> (summary: String, expanded: Bool)? in
        guard let first = state.book.first else { return nil }
        let key = SummaryPersistence.key(for: first.title, author: first.author)
        let expanded = state.expandedSummary[key] ?? false
        return (summary: first.summary, expanded: expanded)
      }
      // (요약, 펼침여부) 쌍이 같으면 드롭 — Optional 비교를 명시적으로 처리
      .removeDuplicates(by: { lhs, rhs in
        switch (lhs, rhs) {
        case let (l?, r?):
          return l.summary == r.summary && l.expanded == r.expanded
        case (nil, nil):
          return true
        default:
          return false
        }
      })
      .compactMap { $0 }
      .receive(on: DispatchQueue.main)

    summaryPublisher
      .sink { [weak self] pair in
        self?.rootView.applySummaryExpanded(pair.expanded, fullText: pair.summary)
      }
      .store(in: &cancellables)

    // 3) 버튼 탭 → 액션 전송 (타입 명시로 추론 돕기)
    rootView.foldSummaryButton
      .publisher(for: .touchUpInside)
      .compactMap { [weak self] (_: Void) -> String? in
        self?.viewStore.currentSummaryKey
      }
      .map { (key: String) -> BookList.Action in
        .view(.summaryToggleTapped(key: key))
      }
      .sink { [weak self] action in
        self?.store.send(action)
      }
      .store(in: &cancellables)
  }
}
