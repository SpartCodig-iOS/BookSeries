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
  
  // 시리즈 버튼 전용 cancellables
  private var seriesButtonCancellables = Set<AnyCancellable>()

  public init(store: StoreOf<BookList>) {
    super.init(rootView: BookListView(), store: store)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  // MARK: - Memory Management
  
  deinit {
    // 시리즈 버튼 전용 cancellables 정리
    seriesButtonCancellables.removeAll()
    // BaseViewController.deinit이 자동으로 main cancellables을 정리함
  }
  
  // MARK: - BaseViewController Override
  
  /// BookList State에서 에러 추출
  public override func extractError(from state: BookList.State) -> String? {
    return state.errorMessage
  }
  
  /// BookList 특화 에러 처리
  public override func handleError(_ errorMessage: String) {
    // BookList 특화 에러 처리 로직
    // 로딩 상태 해제, 특정 UI 업데이트 등
    rootView.hideLoading()
    
    // 에러 알림 표시 (BaseViewController의 구현을 직접 호출)
    showErrorAlert(message: errorMessage)
  }
  
  /// 에러 알림 표시 (BaseViewController 기능을 확장)
  private func showErrorAlert(message: String) {
    let alert = UIAlertController(
      title: "오류",
      message: message,
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
      // 알림을 닫을 때 에러 상태 클리어
      self?.safeSend(.view(.errorDismissed))
    })
    
    // 메인 스레드에서 실행 보장
    DispatchQueue.main.async { [weak self] in
      self?.present(alert, animated: true)
    }
  }

  public override func setupView() {
    super.setupView()
    view.backgroundColor = .white
    navigationItem.title = "Harry Potter Series"
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
    
    bindSummaryToggleAction()
    bindSeriesButtonActions()
  }
  
  private func bindSummaryToggleAction() {
    rootView.foldSummaryButton
      .publisher(for: .touchUpInside)
      .compactMap { [weak self] _ in self?.viewStore.currentSummaryKey }
      .map { key in BookList.Action.view(.summaryToggleTapped(key: key)) }
      .sink { [weak self] action in self?.safeSend(action) }
      .store(in: &cancellables)
  }

  private func bindSeriesButtonActions() {
    // 기존 시리즈 버튼 액션들만 정리
    seriesButtonCancellables.removeAll()
    
    // 각 시리즈 버튼에 대해 개별적으로 바인딩
    rootView.getSeriesButtons().forEach { button in
      button.publisher(for: .touchUpInside)
        .map { _ in button.tag }
        .map { index in BookList.Action.view(.seriesSelected(index)) }
        .sink { [weak self] action in self?.safeSend(action) }
        .store(in: &seriesButtonCancellables)


    }
  }


  public override func bindState() {
    super.bindState()
    
    bindLoadingState()
    bindBooksCountChange()
    bindSelectedBookIndexChange()
    bindDisplayData()
  }
  
  private func bindLoadingState() {
    // BaseViewController의 최적화된 publisher 활용
    optimizedPublisher(\.isLoading)
      .sink { [weak self] isLoading in
        if isLoading {
          self?.rootView.showLoading()
        } else {
          self?.rootView.hideLoading()
        }
      }
      .store(in: &cancellables)
  }
  
  private func bindBooksCountChange() {
    // BaseViewController의 최적화된 publisher로 통일
    optimizedPublisher(\.book)
      .map(\.count)
      .sink { [weak self] count in
        self?.rootView.setupSeriesButtons(count: count)
        if count > 0 {
          self?.bindSeriesButtonActions()
        }
      }
      .store(in: &cancellables)
  }
  
  private func bindSelectedBookIndexChange() {
    // 선택된 책 인덱스 변경 감지
    optimizedPublisher(\.selectedBookIndex)
      .sink { [weak self] index in
        self?.rootView.updateSelectedSeriesButton(index: index)
      }
      .store(in: &cancellables)

  }
  
  private func bindDisplayData() {
    // BaseViewController의 최적화된 publisher 활용
    optimizedPublisher(\.displayData)
      .sink { [weak self] displayData in
        guard let self = self, let data = displayData else {
          self?.navigationItem.title = "No Books"
          return
        }
        
        // UI 업데이트
        self.updateUI(with: data)
      }
      .store(in: &cancellables)


  }
  
  private func updateUI(with data: BookDisplayData) {
    let book = data.book
    
    // 네비게이션 타이틀
    navigationItem.title = book.title
    
    // 메인 UI 구성
    rootView.configure(
      title: book.title,
      author: book.author,
      releasedDate: book.releaseDate,
      pages: book.pages,
      seriesNumber: data.seriesNumber,
      totalSeries: data.totalSeries,
      image: book.image,
      dedication: book.dedication,
      summary: book.summary,
      chapters: book.chapters
    )
    
    // 요약 펼침 상태
    rootView.applySummaryExpanded(data.isSummaryExpanded, fullText: book.summary)
  }
}
