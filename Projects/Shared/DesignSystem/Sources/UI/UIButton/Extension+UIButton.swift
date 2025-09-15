//
//  Extension+UIButton.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 9/9/25.
//

import UIKit

import UIKit

public struct ButtonStyle {
  public enum Kind { case plain, tinted, filled, gray }

  public var kind: Kind = .plain
  public var titleFont: UIFont = .pretendardFont(family: .bold, size: 14)
  public var titleColor: UIColor = .systemBlue
  public var backgroundColor: UIColor = .clear
  public var cornerRadius: CGFloat = 6
  public var contentInsets: NSDirectionalEdgeInsets =
    .init(top: 4, leading: 8, bottom: 4, trailing: 8)
  public var borderWidth: CGFloat = 0
  public var borderColor: UIColor? = nil

  public static let summaryToggle = ButtonStyle()
}

public extension UIButton {
  @discardableResult
  func create(_ style: ButtonStyle = .summaryToggle, title: String? = nil) -> Self {
    applyStyle(style, title: title)
  }

  static func make(_ style: ButtonStyle = .summaryToggle,
                   title: String? = nil,
                   target: Any? = nil,
                   action: Selector? = nil) -> UIButton {
    let b = UIButton(type: .system).applyStyle(style, title: title)
    if let target, let action { b.addTarget(target, action: action, for: .touchUpInside) }
    return b
  }

  @discardableResult
  func applyStyle(_ style: ButtonStyle, title: String? = nil) -> Self {
    if #available(iOS 15.0, *) {
      // 1) 구성 객체 선택
      var config: UIButton.Configuration = {
        switch style.kind {
          case .plain:  return .plain()
          case .tinted: return .tinted()
          case .filled: return .filled()
          case .gray:   return .gray()
        }
      }()

      // 2) 제목 + 폰트
      let finalTitle = title ?? (self.currentTitle ?? "")
      var attrs = AttributeContainer()
      attrs.font = style.titleFont
      config.attributedTitle = AttributedString(finalTitle, attributes: attrs)

      // 3) 색/인셋
      config.baseForegroundColor = style.titleColor
      config.contentInsets = style.contentInsets

      // 4) 배경
      config.baseBackgroundColor = style.backgroundColor
      // cornerRadius는 configuration에 고정값 API가 제한적이라 layer로 처리
      self.configuration = config

      // 5) 모서리/테두리(layer로 처리)
      layer.cornerRadius = style.cornerRadius
      layer.masksToBounds = true
      layer.borderWidth = style.borderWidth
      layer.borderColor = style.borderColor?.cgColor

    } else {
      // iOS 14 이하 폴백
      if let title { setTitle(title, for: .normal) }
      setTitleColor(style.titleColor, for: .normal)
      titleLabel?.font = style.titleFont
      backgroundColor = style.backgroundColor
      layer.cornerRadius = style.cornerRadius
      layer.masksToBounds = true
      contentEdgeInsets = UIEdgeInsets(
        top: style.contentInsets.top,
        left: style.contentInsets.leading,
        bottom: style.contentInsets.bottom,
        right: style.contentInsets.trailing
      )
      layer.borderWidth = style.borderWidth
      layer.borderColor = style.borderColor?.cgColor
    }
    return self
  }
}
