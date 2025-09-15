//
//  BookListView.swift
//  Presentation
//
//  Created by Wonji Suh  on 9/8/25.
//

import UIKit
import Shared
import SnapKit
import Then

public final class BookListView: BaseView {

  private let rootView = UIView()
  
  // MARK: - Skeleton View
  
  private lazy var skeletonView = BookListSkeletonView()

  // MARK: - Main Components
  
  // 상단(고정) + 하단(스크롤) 컨테이너
  private let mainVerticalStack = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 0
    $0.alignment = .fill
    $0.distribution = .fill
  }

  // 컴포넌트 뷰들
  private let headerView = BookListHeaderView()
  private let seriesButtonsView = SeriesButtonsView()
  private let bookCardView = BookCardView()
  private let bookDetailsView = BookDetailsView()
  private let chaptersView = ChaptersView()

  // MARK: - 스크롤 영역

  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
  }
  private let scrollContentView = UIView()
  private let scrollStack = UIStackView.vertical(spacing: 24, alignment: .fill, distribution: .fill)

  // MARK: - Life cycle

  public override func addView() {
    super.addView()
    addSubview(rootView)
    addSubview(skeletonView)
    setupViewHierarchy()
    setupConstraints()
    
    // 초기에는 스켈레톤 뷰 표시
    showSkeleton()
  }

  private func setupViewHierarchy() {
    // 메인 구조 설정
    rootView.addSubviews(mainVerticalStack)
    mainVerticalStack.addArrangedSubviews(headerView, seriesButtonsView, scrollView)

    // 간격 설정
    mainVerticalStack.setCustomSpacing(24, after: headerView)
    mainVerticalStack.setCustomSpacing(16, after: seriesButtonsView)
    
    // 스크롤 내부 구조
    scrollView.addSubviews(scrollContentView)
    scrollContentView.addSubviews(scrollStack)

    // 스크롤 스택에 컴포넌트 추가
    scrollStack.addArrangedSubviews(bookCardView, bookDetailsView, chaptersView)

    // ✅ 하단 safe area padding view 추가
    let bottomSpacer = UIView()
    scrollStack.addArrangedSubview(bottomSpacer)
    bottomSpacer.snp.makeConstraints { make in
      // safe area bottom inset만큼 확보
      make.height.equalTo(self.safeAreaInsets.bottom).priority(.required)
    }

    scrollStack.setCustomSpacing(20, after: bookCardView)

  }

  private func setupConstraints() {
    // rootView: 안전영역
    rootView.snp.makeConstraints { make in
      make.edges.equalTo(self.safeAreaLayoutGuide)
    }
    
    // skeletonView: 안전영역
    skeletonView.snp.makeConstraints { make in
      make.edges.equalTo(self.safeAreaLayoutGuide)
    }

    // 메인 스택: 상단 여백 + 좌우 20 + 하단 고정
    mainVerticalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview()
    }

    // 스크롤 컨텐츠 고정 패턴
    scrollContentView.snp.makeConstraints { make in
      make.edges.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(scrollView.frameLayoutGuide)
    }
    scrollStack.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Public API

  public func configure(
    title: String,
    author: String,
    releasedDate: String,
    pages: Int,
    seriesNumber: Int? = nil,
    totalSeries: Int? = nil,
    image: String? = nil,
    dedication: String,
    summary: String,
    chapters: [String] = []
  ) {
    // 헤더 설정
    headerView.configure(title: title, seriesNumber: seriesNumber)
    
    // 카드 설정
    let cardData = BookCardView.BookCardData(
      title: title,
      author: author,
      releaseDate: releasedDate,
      pages: pages,
      image: image
    )
    bookCardView.configure(with: cardData)
    
    // 상세 정보 설정
    let detailsData = BookDetailsView.BookDetailsData(
      dedication: dedication,
      summary: summary
    )
    bookDetailsView.configure(with: detailsData)
    
    // 목차 설정
    chaptersView.configure(chapters: chapters)
  }

  public func applySummaryExpanded(_ expanded: Bool, fullText: String) {
    bookDetailsView.applySummaryExpanded(expanded, fullText: fullText)
  }

  // MARK: - Component Access (for ViewController)
  
  public var foldSummaryButton: UIButton {
    return bookDetailsView.foldSummaryButton
  }
  
  // MARK: - Series Buttons Setup
  
  public func setupSeriesButtons(count: Int) {
    seriesButtonsView.setupButtons(count: count)
  }
  
  public func updateSelectedSeriesButton(index: Int) {
    seriesButtonsView.updateSelectedButton(index: index)
  }
  
  public func getSeriesButtons() -> [UIButton] {
    return seriesButtonsView.getButtons()
  }
  
  // MARK: - Loading State Management
  
  public func showSkeleton() {
    skeletonView.isHidden = false
    rootView.isHidden = true
  }
  
  public func hideSkeleton() {
    skeletonView.stopShimmerAnimation()
    skeletonView.isHidden = true
    rootView.isHidden = false
  }
  
  public func showLoading() {
    showSkeleton()
  }
  
  public func hideLoading() {
    hideSkeleton()
  }
}

