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

  // 전체 컨테이너 (수직 스택뷰)
  private let mainVerticalStack = UIStackView().then { stack in
    stack.axis = .vertical
    stack.spacing = 30
    stack.alignment = .fill
    stack.distribution = .fill
  }

  // MARK: - 상단 헤더 섹션

  // 상단 헤더 컨테이너
  private let headerContainer = UIView()

  // 큰 제목 라벨 (상단)
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

  // 큰 시리즈 번호 (상단)
  private lazy var mainSeriesNumberLabel: UILabel = {
    let label = UILabel()
    label.text = "1"
    label.font = UIFont.pretendardFont(family: .bold, size: 18)
    label.textColor = .white
    label.textAlignment = .center
    label.backgroundColor = .systemBlue

    // 원형으로 만들기 위한 설정
    label.layer.cornerRadius = 25 // width/height의 절반
    label.clipsToBounds = true

    return label
  }()

  // MARK: - 하단 카드 섹션

  // 카드 컨테이너
  private let cardContainer = UIView().then {
    $0.backgroundColor = .systemBackground
    $0.layer.cornerRadius = 12
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.1
    $0.layer.shadowOffset = CGSize(width: 0, height: 2)
    $0.layer.shadowRadius = 8
  }

  // 카드 내부 수평 스택뷰
  private let cardHorizontalStack = UIStackView().then { stack in
    stack.axis = .horizontal
    stack.spacing = 16
    stack.alignment = .top
    stack.distribution = .fill
  }

  // 책 이미지 뷰
  private lazy var bookImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .systemGray5
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8

    // placeholder 텍스트 추가
    let label = UILabel()
    label.text = "Book\nImage"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .systemGray3
    label.numberOfLines = 2
    imageView.addSubview(label)

    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    return imageView
  }()

  // 카드 내부 책 정보 컨테이너
  private let cardInfoVerticalStack = UIStackView().then { stack in
    stack.axis = .vertical
    stack.spacing = 4
    stack.alignment = .leading
    stack.distribution = .fill
  }

  // 카드 제목 라벨 (작게)
  private lazy var cardTitleLabel = UILabel.createLabel(
    for: "Harry Potter and the Philosopher's Stone",
    family: .bold,
    size: 20,
    color: .basicBlack
  ).then {
    $0.numberOfLines = 0
    $0.lineBreakMode = .byWordWrapping
  }

  // 작가 라벨
  private lazy var authorLabel = UILabel.createLabel(
    for: "J. K. Rowling",
    family: .medium,
    size: 14,
    color: .basicBlack
  )

  // 출간일 라벨
  private lazy var releasedDateLabel = UILabel.createLabel(
    for: "Released June 26, 1997",
    family: .regular,
    size: 12,
    color: .systemGray
  )

  // 페이지수 라벨
  private lazy var pagesLabel = UILabel.createLabel(
    for: "Pages 223",
    family: .regular,
    size: 12,
    color: .systemGray
  )

  public override func addView() {
    super.addView()
    addSubview(rootView)
    setupViewHierarchy()
    setupConstraints()
  }

  private func setupViewHierarchy() {
    // 상단 헤더 설정
    headerContainer.addSubviews(mainTitleLabel, mainSeriesNumberLabel)


    // 카드 정보 스택 설정
    cardInfoVerticalStack.addArrangedSubviews(
        cardTitleLabel, authorLabel, releasedDateLabel, pagesLabel
    )

    // 카드 수평 스택 설정
    cardHorizontalStack.addArrangedSubviews(bookImageView, cardInfoVerticalStack)


    // 카드 컨테이너에 스택 추가
    cardContainer.addSubviews(cardHorizontalStack)

    // 메인 수직 스택에 헤더와 카드 추가
    mainVerticalStack.addArrangedSubviews(headerContainer, cardContainer)

    rootView.addSubviews(mainVerticalStack)
  }

  private func setupConstraints() {
    // rootView: 안전영역에 꽉 차도록
    rootView.snp.makeConstraints { make in
      make.edges.equalTo(self.safeAreaLayoutGuide)
    }

    // mainVerticalStack: 전체 컨테이너
    mainVerticalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }

    // MARK: - 상단 헤더 제약조건

    // mainTitleLabel: 상단 큰 제목
    mainTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.centerX.equalToSuperview()
    }

    // mainSeriesNumberLabel: 상단 큰 시리즈 번호
    mainSeriesNumberLabel.snp.makeConstraints { make in
      make.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(50) // 50x50 원형
      make.bottom.equalToSuperview()
    }

    // MARK: - 카드 섹션 제약조건

    // cardHorizontalStack: 카드 내부 스택
    cardHorizontalStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalToSuperview().offset(-8)
    }

    // bookImageView: 책 이미지 크기 고정
    bookImageView.snp.makeConstraints { make in
      make.width.equalTo(80)
      make.height.equalTo(120)
    }
  }

  // MARK: - Public Methods

  public func setTitle(_ text: String) {
    mainTitleLabel.text = text
    cardTitleLabel.text = text
  }

  public func setSeriesNumber(_ number: Int, total: Int? = nil) {
    if total != nil {
      mainSeriesNumberLabel.text = "\(number)"
      // total 정보는 필요시 다른 방식으로 표시
    } else {
      mainSeriesNumberLabel.text = "\(number)"
    }
  }

  public func setAuthor(_ author: String) {
    authorLabel.text = "Author \(author)"
    authorLabel.textColor = .basicBlack
    authorLabel.font = UIFont.pretendardFont(family: .medium, size: 14)
  }

  public func setReleasedDate(_ date: String) {
    releasedDateLabel.text = "Released \(date)"
    releasedDateLabel.textColor = .systemGray
    releasedDateLabel.font = UIFont.pretendardFont(family: .regular, size: 12)
  }

  public func setPages(_ pages: Int) {
    pagesLabel.text = "Pages \(pages)"
    pagesLabel.textColor = .systemGray
    pagesLabel.font = UIFont.pretendardFont(family: .regular, size: 12)
  }

  public func setBookImage(_ image:  String) {
    bookImageView.image = UIImage(ImageAsset(rawValue: (ImageAsset(rawValue: image  )?.rawValue)!) ?? .empty)
    // placeholder 텍스트 숨기기/보이기
    print("\(image)")
    bookImageView.subviews.first?.isHidden = (image != nil)
  }

  // 시리즈 번호 표시/숨김
  public func setSeriesNumberVisible(_ visible: Bool) {
    mainSeriesNumberLabel.isHidden = !visible
  }

  // 모든 정보를 한번에 설정하는 편의 메서드
  public func configure(
    title: String,
    author: String,
    releasedDate: String,
    pages: Int,
    seriesNumber: Int? = nil,
    totalSeries: Int? = nil,
    image: String
  ) {
    setTitle(title)
    setAuthor(author)
    setReleasedDate(releasedDate.toLongUSDate() ?? "")
    setPages(pages)
    setBookImage(image)

    if let seriesNumber {
      setSeriesNumber(seriesNumber, total: totalSeries)
      setSeriesNumberVisible(true)
    } else {
      setSeriesNumberVisible(false)
    }
  }
}

