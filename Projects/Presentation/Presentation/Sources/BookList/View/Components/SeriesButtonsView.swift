//
//  SeriesButtonsView.swift
//  Presentation
//
//  Created by Claude on 9/10/25.
//

import UIKit
import Shared
import SnapKit
import Then

public final class SeriesButtonsView: BaseView {
  
  // MARK: - UI Components
  
  private let seriesScrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
  }
  
  private let seriesButtonStack = UIStackView.horizontal(spacing: 12, alignment: .center)
  
  // MARK: - Properties
  
  private var seriesButtons: [UIButton] = []
  
  // MARK: - Life cycle
  
  public override func addView() {
    super.addView()
    setupViewHierarchy()
    setupConstraints()
  }
  
  private func setupViewHierarchy() {
    addSubviews(seriesScrollView)
    seriesScrollView.addSubviews(seriesButtonStack)
  }
  
  private func setupConstraints() {
    seriesScrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(44)
    }
    
    seriesButtonStack.snp.makeConstraints { make in
      make.edges.equalTo(seriesScrollView.contentLayoutGuide)
      make.height.equalTo(seriesScrollView.frameLayoutGuide)
      make.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  // MARK: - Public Methods
  
  public func setupButtons(count: Int) {
    // 기존 버튼들 제거
    clearButtons()
    
    // count가 0 이하이면 버튼 생성하지 않음
    guard count > 0 else { return }
    
    // 데이터 개수에 맞게 시리즈 버튼 생성
    for i in 1...count {
      let button = createSeriesButton(number: i, index: i - 1)
      seriesButtons.append(button)
      seriesButtonStack.addArrangedSubview(button)
      
      // 버튼 크기 제약
      button.snp.makeConstraints { make in
        make.width.height.equalTo(44)
      }
    }
    
    // 첫 번째 버튼을 선택 상태로 설정
    updateSelectedButton(index: 0)
  }
  
  public func updateSelectedButton(index: Int) {
    // ViewController에서 전달받은 인덱스로 UI만 업데이트
    seriesButtons.enumerated().forEach { (buttonIndex, button) in
      if buttonIndex == index {
        button.isSelected = true
        button.backgroundColor = .blue50.withAlphaComponent(0.6)
      } else {
        button.isSelected = false
        button.backgroundColor = .gray.withAlphaComponent(0.3)
      }
    }
  }
  
  public func getButtons() -> [UIButton] {
    return seriesButtons
  }
  
  // MARK: - Private Methods
  
  private func createSeriesButton(number: Int, index: Int) -> UIButton {
    return UIButton().then {
      $0.setTitle("\(number)", for: .normal)
      $0.titleLabel?.font = UIFont.pretendardFont(family: .medium, size: 16)
      $0.setTitleColor(.basicBlack, for: .normal)
      $0.setTitleColor(.staticWhite, for: .selected)
      $0.backgroundColor = .gray.withAlphaComponent(0.3)
      $0.layer.cornerRadius = 22
      $0.clipsToBounds = true
      $0.tag = index  // 0-based index for seriesSelected action
    }
  }
  
  private func clearButtons() {
    seriesButtons.forEach { button in
      seriesButtonStack.removeArrangedSubview(button)
      button.removeFromSuperview()
    }
    seriesButtons.removeAll()
  }
}