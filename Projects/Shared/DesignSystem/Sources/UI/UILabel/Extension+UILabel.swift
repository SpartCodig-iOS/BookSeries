//
//  Extension+UILabel.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 9/5/25.
//

import UIKit

extension UILabel {
  static func createLabel(
    for text: String,
    family: PretendardFontFamily,
    size: CGFloat,
    color: UIColor
  ) -> UILabel {
    let label = UILabel()
    label.text =  text
    label.font = .pretendardFont(family: family, size: size)
    label.textColor = color
    label.textAlignment = .center
    return label
  }
}
