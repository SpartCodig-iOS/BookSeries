//
//   Extension+Image.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 9/5/25.
//

import Foundation
import UIKit

public extension UIImage {
  func roundedImage() -> UIImage? {
    let imageSize = CGSize(width: self.size.width, height: self.size.height)
    let radius = min(self.size.width, self.size.height) / 2.0
    let roundedRect = CGRect(origin: .zero, size: imageSize).insetBy(dx: radius, dy: radius)

    let renderer = UIGraphicsImageRenderer(size: imageSize)
    let roundedImage = renderer.image { context in
      let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: radius)
      context.cgContext.addPath(path.cgPath)
      context.cgContext.clip()
      self.draw(in: roundedRect)
    }
    return roundedImage
  }

  func setRoundedCorners() -> UIImage? {
    let imageView = UIImageView(image: self)
    let layer = imageView.layer
    layer.masksToBounds = true
    layer.cornerRadius = imageView.frame.width / 2.0
    UIGraphicsBeginImageContext(imageView.bounds.size)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    layer.render(in: context)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    return roundedImage
  }
}


public extension UIImage {
  convenience init?(_ asset: ImageAsset) {
    self.init(named: asset.rawValue, in: Bundle.module, with: nil)
  }

  convenience init?(assetName: String) {
    self.init(named: assetName, in: Bundle.module, with: nil)
  }
}
