//
//  BookListHeaderView.swift
//  Presentation
//
//  Created by Claude on 9/10/25.
//

import UIKit
import Shared
import SnapKit
import Then

public final class BookListHeaderView: BaseView {
  
  // MARK: - UI Components
  
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
    $0.backgroundColor = .blue50.withAlphaComponent(0.6)
    $0.layer.cornerRadius = 25
    $0.clipsToBounds = true
  }
  
  // MARK: - Life cycle
  
  public override func addView() {
    super.addView()
    setupViewHierarchy()
    setupConstraints()
  }
  
  private func setupViewHierarchy() {
    addSubviews(mainTitleLabel, mainSeriesNumberLabel)
  }
  
  private func setupConstraints() {
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
  }
  
  // MARK: - Public Methods
  
  public func configure(title: String, seriesNumber: Int?) {
    mainTitleLabel.text = title
    
    if let seriesNumber {
      mainSeriesNumberLabel.text = "\(seriesNumber)"
      mainSeriesNumberLabel.isHidden = false
    } else {
      mainSeriesNumberLabel.isHidden = true
    }
  }
  
  public func setTitle(_ title: String) {
    mainTitleLabel.text = title
  }
  
  public func setSeriesNumber(_ number: Int) {
    mainSeriesNumberLabel.text = "\(number)"
    mainSeriesNumberLabel.isHidden = false
  }
  
  public func hideSeriesNumber() {
    mainSeriesNumberLabel.isHidden = true
  }
}