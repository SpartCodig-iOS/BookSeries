//
//  Extension+UiView.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 9/9/25.
//

import UIKit

public struct ContainerStyle {
  public var backgroundColor: UIColor = .systemBackground
  public var cornerRadius: CGFloat = 12
  public var shadowColor: UIColor = .black
  public var shadowOpacity: Float = 0.1
  public var shadowOffset: CGSize = .init(width: 0, height: 2)
  public var shadowRadius: CGFloat = 8

  public init(backgroundColor: UIColor = .systemBackground,
              cornerRadius: CGFloat = 12,
              shadowColor: UIColor = .black,
              shadowOpacity: Float = 0.1,
              shadowOffset: CGSize = .init(width: 0, height: 2),
              shadowRadius: CGFloat = 8) {
    self.backgroundColor = backgroundColor
    self.cornerRadius = cornerRadius
    self.shadowColor = shadowColor
    self.shadowOpacity = shadowOpacity
    self.shadowOffset = shadowOffset
    self.shadowRadius = shadowRadius
  }

  public static let `default` = ContainerStyle()
}

public extension UIView {

  func addSubviews(_ views: UIView...) {
      views.forEach(addSubview)
  }

  /// 한 줄 생성: UIView.makeContainer()
  static func makeContainer(_ style: ContainerStyle = .default) -> UIView {
    UIView().applyContainerStyle(style)
  }

  /// 체이닝 적용: UIView().applyContainerStyle()
  @discardableResult
  func applyContainerStyle(_ style: ContainerStyle = .default) -> Self {
    backgroundColor = style.backgroundColor
    layer.cornerRadius = style.cornerRadius
    layer.shadowColor = style.shadowColor.cgColor
    layer.shadowOpacity = style.shadowOpacity
    layer.shadowOffset = style.shadowOffset
    layer.shadowRadius = style.shadowRadius
    layer.masksToBounds = false
    return self
  }
}
