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

  // 상단(고정) + 하단(스크롤) 컨테이너
  private let mainVerticalStack = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 0
    $0.alignment = .fill
    $0.distribution = .fill
  }

  // MARK: - 헤더(고정)

  private let headerContainer = UIView()

  private lazy var mainTitleLabel = UILabel.createLabel(
    for: "Harry Potter and the Philosopher's Stone",
    family: .bold,
    size: 24,
    color: .basicBlack
  ).then {
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.lineBreakMode = .byWordWrapping
  }

  private lazy var mainSeriesNumberLabel = UILabel.createLabel(
    for: "1",
    family: .bold,
    size: 18,
    color: .staticWhite
  ).then {
    $0.textAlignment = .center
    $0.backgroundColor = .blue30
    $0.layer.cornerRadius = 25
    $0.clipsToBounds = true
  }

  // MARK: - 스크롤 영역

  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
  }
  private let scrollContentView = UIView()
  private let scrollStack = UIStackView.vertical(spacing: 24, alignment: .fill, distribution: .fill)

  // MARK: - 카드 섹션

  private let cardContainer = UIView.makeContainer(.init(backgroundColor: .clear, cornerRadius: 12))

  private let cardHorizontalStack = UIStackView.horizontal(spacing: 16, alignment: .leading)

  private lazy var bookImageView = UIImageView().then {
    $0.backgroundColor = .systemGray5
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8

    // placeholder
    let label = UILabel.createLabel(
      for: "Book\nImage",
      family: .regular,
      size: 12,
      color: .gray40
    ).then {
      $0.numberOfLines = 2
      $0.textAlignment = .center
    }
    $0.addSubview(label)
    label.snp.makeConstraints { $0.center.equalToSuperview() }
  }

  private lazy var cardInfoVerticalStack = UIStackView.vertical(spacing: 4, alignment: .leading, distribution: .fill)

  private lazy var cardTitleLabel = UILabel.createLabel(
    for: "Harry Potter and the Philosopher's Stone",
    family: .bold,
    size: 20,
    color: .basicBlack
  ).then {
    $0.numberOfLines = 0
    $0.lineBreakMode = .byWordWrapping
  }

  private lazy var authorLabel = UILabel.createLabel(
    for: "J. K. Rowling",
    family: .medium,
    size: 14,
    color: .basicBlack
  )

  private lazy var releasedDateLabel = UILabel.createLabel(
    for: "Released June 26, 1997",
    family: .regular,
    size: 12,
    color: .systemGray
  )

  private lazy var pagesLabel = UILabel.createLabel(
    for: "Pages 223",
    family: .regular,
    size: 12,
    color: .systemGray
  )

  // MARK: - 상세(헌정/요약) 섹션

  private let bookDetailsContainer = UIView.makeContainer(.init(backgroundColor: .clear))

  private lazy var dedicationStack = UIStackView.vertical(spacing: 8, alignment: .leading, distribution: .fill)

  private lazy var dedicationTitleLabel = UILabel.createLabel(
    for: "Dedication",
    family: .bold,
    size: 18,
    color: .basicBlack
  )

  private lazy var dedicationTextLabel = UILabel.createLabel(
    for: "Dedication Summary",
    family: .regular,
    size: 14,
    color: .darkGray.withAlphaComponent(0.5)
  ).then {
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }

  private lazy var summaryStack = UIStackView.vertical(spacing: 8, alignment: .leading, distribution: .fill)

  private lazy var summaryTitleLabel = UILabel.createLabel(
    for: "Summary",
    family: .bold,
    size: 18,
    color: .basicBlack
  )

  private lazy var summaryTextLabel = UILabel.createLabel(
    for: "Summary Text",
    family: .regular,
    size: 14,
    color: .darkGray.withAlphaComponent(0.5)
  ).then {
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }

  // Summary 토글 버튼 (우측 정렬)
  lazy var foldSummaryButton = UIButton()
    .create(.summaryToggle, title: "더보기")
    .then {
      $0.contentHorizontalAlignment = .right
      $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

  // ⬇️ Summary 토글 상태/키
  private var fullSummaryText: String = ""
  private var isSummaryExpanded: Bool = false
  private var summaryPersistenceKey: String?

  // MARK: - 목차(Chapters) 섹션

  private let chaptersContainer = UIView()
  private let chaptersTitleLabel = UILabel.createLabel(
    for: "Chapters",
    family: .bold,
    size: 18,
    color: .basicBlack
  ).then {
    $0.textAlignment = .left
  }

  private let chaptersListStack = UIStackView.vertical(
    spacing: 8,
    alignment: .leading,
    distribution: .fill
  )

  // MARK: - Life cycle

  public override func addView() {
    super.addView()
    addSubview(rootView)
    setupViewHierarchy()
    setupConstraints()
  }

  private func setupViewHierarchy() {
    // 상단: 헤더 + 하단: 스크롤뷰
    rootView.addSubviews(mainVerticalStack)
    mainVerticalStack.addArrangedSubviews(headerContainer, scrollView)

    mainVerticalStack.setCustomSpacing(24, after: headerContainer)
    
    scrollStack.setCustomSpacing(32, after: cardContainer)
    // 헤더
    headerContainer.addSubviews(mainTitleLabel, mainSeriesNumberLabel)

    // 스크롤 내부 구조
    scrollView.addSubviews(scrollContentView)
    scrollContentView.addSubviews(scrollStack)

    // 스크롤 스택에 섹션 추가(카드 → 상세 → 목차)
    scrollStack.addArrangedSubviews(cardContainer, bookDetailsContainer, chaptersContainer)

    // 카드 섹션 내부
    cardInfoVerticalStack.addArrangedSubviews(cardTitleLabel, authorLabel, releasedDateLabel, pagesLabel)
    cardHorizontalStack.addArrangedSubviews(bookImageView, cardInfoVerticalStack)
    cardContainer.addSubviews(cardHorizontalStack)

    // 상세 섹션 내부
    bookDetailsContainer.addSubviews(dedicationStack, summaryStack)
    dedicationStack.addArrangedSubviews(dedicationTitleLabel, dedicationTextLabel)
    summaryStack.addArrangedSubviews(summaryTitleLabel, summaryTextLabel, foldSummaryButton)

    // 목차 섹션 내부
    chaptersContainer.addSubviews(chaptersTitleLabel, chaptersListStack)
  }

  private func setupConstraints() {
    // rootView: 안전영역
    rootView.snp.makeConstraints { make in
      make.edges.equalTo(self.safeAreaLayoutGuide)
    }

    // 메인 스택: 상단 여백 + 좌우 20 + 하단 고정
    mainVerticalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview()
    }


    // 헤더
    mainTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.centerX.equalToSuperview()
    }
    mainSeriesNumberLabel.snp.makeConstraints { make in
      make.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(50)
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

    // 카드
    cardHorizontalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalToSuperview().offset(-8)
    }
    bookImageView.snp.makeConstraints { make in
      make.width.equalTo(80)
      make.height.equalTo(120)
    }

    // 상세(헌정/요약)
    dedicationStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(0)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    summaryStack.snp.makeConstraints { make in
      make.top.equalTo(dedicationStack.snp.bottom).offset(24)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview() // 컨테이너 높이 확정
    }

    // Summary 버튼: 스택 내부에서 우측 정렬
    foldSummaryButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview()                 // summaryStack의 trailing(이미 -20 인셋 적용됨)
      make.leading.greaterThanOrEqualToSuperview()
    }

    // 목차(Chapters)
    chaptersTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(0)            // Summary와는 scrollStack spacing=24로 띄움
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    chaptersListStack.snp.makeConstraints { make in
      make.top.equalTo(chaptersTitleLabel.snp.bottom).offset(8) // 타이틀-첫 항목 8
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview()
    }
  }

  // MARK: - Public API

  public func setTitle(_ text: String) {
    mainTitleLabel.text = text
    cardTitleLabel.text = text

    // 제목 기반으로 펼침 상태 복원
    summaryPersistenceKey = "SummaryExpanded.\(text)"
    if let key = summaryPersistenceKey {
      isSummaryExpanded = UserDefaults.standard.bool(forKey: key) // 기본 false
    }
  }

  public func setSeriesNumber(_ number: Int, total: Int? = nil) {
    mainSeriesNumberLabel.text = "\(number)"
  }

  public func setAuthor(_ author: String) {
    authorLabel.text = "Author \(author)"
    authorLabel.textColor = .basicBlack
    authorLabel.font = UIFont.pretendardFont(family: .medium, size: 14)
  }

  public func setReleasedDate(_ date: String) {
    releasedDateLabel.text = "Released \(date.toLongUSDate() ?? date)"
    releasedDateLabel.textColor = .systemGray
    releasedDateLabel.font = UIFont.pretendardFont(family: .regular, size: 12)
  }

  public func setPages(_ pages: Int) {
    pagesLabel.text = "Pages \(pages)"
    pagesLabel.textColor = .systemGray
    pagesLabel.font = UIFont.pretendardFont(family: .regular, size: 12)
  }

  public func setBookImage(_ image: String?) {
    bookImageView.image = UIImage(assetName: image ?? "")
    bookImageView.subviews.first?.isHidden = (bookImageView.image != nil)
  }

  public func setSeriesNumberVisible(_ visible: Bool) {
    mainSeriesNumberLabel.isHidden = !visible
  }

  public func setDedication(_ dedication: String) {
    dedicationTextLabel.text = dedication
  }

  public func setSummary(_ summary: String) {
    fullSummaryText = summary
    updateSummaryUI()
  }

  public func setChapters(_ chapters: [String]) {
    // 기존 제거
    chaptersListStack.arrangedSubviews.forEach {
      chaptersListStack.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
    // 추가
    for title in chapters {
      let label = UILabel()
      label.text = title
      label.font = .systemFont(ofSize: 14)
      label.textColor = .darkGray
      label.numberOfLines = 0
      chaptersListStack.addArrangedSubview(label)
    }
  }

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
    setTitle(title)
    setAuthor(author)
    setReleasedDate(releasedDate)
    setPages(pages)
    setBookImage(image)
    setDedication(dedication)
    setSummary(summary)
    setChapters(chapters)

    if let seriesNumber {
      setSeriesNumber(seriesNumber, total: totalSeries)
      setSeriesNumberVisible(true)
    } else {
      setSeriesNumberVisible(false)
    }
  }

  // MARK: - Summary Toggle (public control from VC)

  public func setSummaryToggleTarget(_ target: Any, action: Selector) {
    foldSummaryButton.addTarget(target, action: action, for: .touchUpInside)
  }

  public func toggleSummary() {
    isSummaryExpanded.toggle()
    updateSummaryUI()
  }

  private func updateSummaryUI() {
    let needsButton = fullSummaryText.count >= 450
    foldSummaryButton.isHidden = !needsButton

    if needsButton {
      if isSummaryExpanded {
        summaryTextLabel.text = fullSummaryText
        foldSummaryButton.setTitle("접기", for: .normal)
      } else {
        summaryTextLabel.text = fullSummaryText.truncated(to: 450)
        foldSummaryButton.setTitle("더보기", for: .normal)
      }
    } else {
      summaryTextLabel.text = fullSummaryText
    }
  }


  public func applySummaryExpanded(_ expanded: Bool, fullText: String) {
    isSummaryExpanded = expanded
    fullSummaryText = fullText
    updateSummaryUI()        // 내부 말줄임/버튼타이틀만 업데이트
  }
}

