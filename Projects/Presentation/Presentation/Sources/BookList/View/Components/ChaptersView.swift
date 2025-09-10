//
//  ChaptersView.swift
//  Presentation
//
//  Created by Claude on 9/10/25.
//

import UIKit
import Shared
import SnapKit
import Then

public final class ChaptersView: BaseView {
  
  // MARK: - UI Components
  
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
    setupViewHierarchy()
    setupConstraints()
  }
  
  private func setupViewHierarchy() {
    addSubviews(chaptersContainer)
    chaptersContainer.addSubviews(chaptersTitleLabel, chaptersListStack)
  }
  
  private func setupConstraints() {
    chaptersContainer.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    chaptersTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(0)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    chaptersListStack.snp.makeConstraints { make in
      make.top.equalTo(chaptersTitleLabel.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Public Methods
  
  public func configure(chapters: [String]) {
    setChapters(chapters)
  }
  
  public func setChapters(_ chapters: [String]) {
    // 기존 제거
    clearChapters()
    
    // 새 목차 추가
    for title in chapters {
      let label = createChapterLabel(title: title)
      chaptersListStack.addArrangedSubview(label)
    }
  }
  
  // MARK: - Private Methods
  
  private func createChapterLabel(title: String) -> UILabel {
    let label = UILabel()
    label.text = title
    label.font = .systemFont(ofSize: 14)
    label.textColor = .darkGray
    label.numberOfLines = 0
    return label
  }
  
  private func clearChapters() {
    chaptersListStack.arrangedSubviews.forEach {
      chaptersListStack.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }
}