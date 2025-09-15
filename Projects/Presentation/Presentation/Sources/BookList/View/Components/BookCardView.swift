//
//  BookCardView.swift
//  Presentation
//
//  Created by Claude on 9/10/25.
//

import UIKit
import Shared
import SnapKit
import Then

public final class BookCardView: BaseView {
  
  // MARK: - UI Components
  
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
    $0.textAlignment = .left
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
  
  // MARK: - Life cycle
  
  public override func addView() {
    super.addView()
    setupViewHierarchy()
    setupConstraints()
  }
  
  private func setupViewHierarchy() {
    addSubviews(cardContainer)
    cardContainer.addSubviews(cardHorizontalStack)
    cardHorizontalStack.addArrangedSubviews(bookImageView, cardInfoVerticalStack)
    cardInfoVerticalStack.addArrangedSubviews(cardTitleLabel, authorLabel, releasedDateLabel, pagesLabel)
  }
  
  private func setupConstraints() {
    cardContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
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
  }
  
  // MARK: - Public Methods
  
  public struct BookCardData {
    let title: String
    let author: String
    let releaseDate: String
    let pages: Int
    let image: String?
  }
  
  public func configure(with data: BookCardData) {
    cardTitleLabel.text = data.title
    
    authorLabel.text = "Author \(data.author)"
    authorLabel.textColor = .basicBlack
    authorLabel.font = UIFont.pretendardFont(family: .medium, size: 14)
    
    releasedDateLabel.text = "Released \(data.releaseDate.toLongUSDate() ?? data.releaseDate)"
    releasedDateLabel.textColor = .systemGray
    releasedDateLabel.font = UIFont.pretendardFont(family: .regular, size: 12)
    
    pagesLabel.text = "Pages \(data.pages)"
    pagesLabel.textColor = .systemGray
    pagesLabel.font = UIFont.pretendardFont(family: .regular, size: 12)
    
    bookImageView.image = UIImage(assetName: data.image ?? "")
    bookImageView.subviews.first?.isHidden = (bookImageView.image != nil)
  }
  
  public func setTitle(_ title: String) {
    cardTitleLabel.text = title
  }
  
  public func setAuthor(_ author: String) {
    authorLabel.text = "Author \(author)"
  }
  
  public func setReleaseDate(_ date: String) {
    releasedDateLabel.text = "Released \(date.toLongUSDate() ?? date)"
  }
  
  public func setPages(_ pages: Int) {
    pagesLabel.text = "Pages \(pages)"
  }
  
  public func setImage(_ image: String?) {
    bookImageView.image = UIImage(assetName: image ?? "")
    bookImageView.subviews.first?.isHidden = (bookImageView.image != nil)
  }
}