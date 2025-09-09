//
//  Extension+UIView.swift
//  Utill
//
//  Created by Wonji Suh  on 9/9/25.
//

import UIKit


public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}


public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach(addArrangedSubview)
    }
}
