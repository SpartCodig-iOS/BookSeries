//
//  BookDetailsView.swift
//  Presentation
//
//  Created by Claude on 9/10/25.
//

import UIKit
import Shared
import SnapKit
import Then

public final class BookDetailsView: BaseView {
  
  // MARK: - UI Components
  
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
  public lazy var foldSummaryButton = UIButton()
    .create(.summaryToggle, title: "더보기")
    .then {
      $0.contentHorizontalAlignment = .right
      $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
  
  // MARK: - Properties
  
  private var fullSummaryText: String = ""
  private var isSummaryExpanded: Bool = false
  
  // MARK: - Life cycle
  
  public override func addView() {
    super.addView()
    setupViewHierarchy()
    setupConstraints()
  }
  
  private func setupViewHierarchy() {
    addSubviews(bookDetailsContainer)
    bookDetailsContainer.addSubviews(dedicationStack, summaryStack)
    dedicationStack.addArrangedSubviews(dedicationTitleLabel, dedicationTextLabel)
    summaryStack.addArrangedSubviews(summaryTitleLabel, summaryTextLabel, foldSummaryButton)
  }
  
  private func setupConstraints() {
    bookDetailsContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    dedicationStack.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(0)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    summaryStack.snp.makeConstraints { make in
      make.top.equalTo(dedicationStack.snp.bottom).offset(24)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview()
    }
    
    // Summary 버튼: 스택 내부에서 우측 정렬
    foldSummaryButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.leading.greaterThanOrEqualToSuperview()
    }
  }
  
  // MARK: - Public Methods
  
  public struct BookDetailsData {
    let dedication: String
    let summary: String
  }
  
  public func configure(with data: BookDetailsData) {
    dedicationTextLabel.text = data.dedication
    setSummary(data.summary)
  }
  
  public func setDedication(_ dedication: String) {
    dedicationTextLabel.text = dedication
  }
  
  public func setSummary(_ summary: String) {
    fullSummaryText = summary
    updateSummaryUI()
  }
  
  public func applySummaryExpanded(_ expanded: Bool, fullText: String) {
    isSummaryExpanded = expanded
    fullSummaryText = fullText
    updateSummaryUI()
  }
  
  public func toggleSummary() {
    isSummaryExpanded.toggle()
    updateSummaryUI()
  }
  
  // MARK: - Private Methods
  
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
}