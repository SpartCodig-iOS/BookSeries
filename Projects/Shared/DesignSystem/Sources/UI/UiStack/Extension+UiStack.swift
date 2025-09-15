//
//  Extension+UiStack.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 9/9/25.
//

import UIKit


public enum StackStyle {
  case mainVertical                 // axis: vertical, spacing: 30
  case cardHorizontal               // axis: horizontal, spacing: 16, alignment: .top
  case custom(axis: NSLayoutConstraint.Axis,
              spacing: CGFloat,
              alignment: UIStackView.Alignment = .fill,
              distribution: UIStackView.Distribution = .fill)
}

public extension UIStackView {
  // 핵심 팩토리
  static func make(_ style: StackStyle,
                   arrangedSubviews: [UIView] = []) -> UIStackView {
    switch style {
      case .mainVertical:
        return UIStackView.vertical(spacing: 30, alignment: .fill, distribution: .fill,
                                    arrangedSubviews: arrangedSubviews)
      case .cardHorizontal:
        return UIStackView.horizontal(spacing: 16, alignment: .top, distribution: .fill,
                                      arrangedSubviews: arrangedSubviews)
      case let .custom(axis, spacing, alignment, distribution):
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = distribution
        return stack
    }
  }
  
  // 편의 생성자: 세로/가로
  static func vertical(spacing: CGFloat = 0,
                       alignment: UIStackView.Alignment = .fill,
                       distribution: UIStackView.Distribution = .fill,
                       arrangedSubviews: [UIView] = []) -> UIStackView {
    let stack = UIStackView(arrangedSubviews: arrangedSubviews)
    stack.axis = .vertical
    stack.spacing = spacing
    stack.alignment = alignment
    stack.distribution = distribution
    return stack
  }
  
  static func horizontal(spacing: CGFloat = 0,
                         alignment: UIStackView.Alignment = .fill,
                         distribution: UIStackView.Distribution = .fill,
                         arrangedSubviews: [UIView] = []) -> UIStackView {
    let stack = UIStackView(arrangedSubviews: arrangedSubviews)
    stack.axis = .horizontal
    stack.spacing = spacing
    stack.alignment = alignment
    stack.distribution = distribution
    return stack
  }
  
  // 자주 쓰는 유틸
  func addArrangedSubviews(_ views: UIView...) { views.forEach(addArrangedSubview) }
  func addArrangedSubviews(_ views: [UIView]) { views.forEach(addArrangedSubview) }
  
  func setArrangedSubviews(_ views: [UIView]) {
    arrangedSubviews.forEach {
      removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
    views.forEach(addArrangedSubview)
  }
}
