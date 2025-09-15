//
//  ServiceBundle.swift
//  Service
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation


// MARK: - Bundle helper (Tuist/SwiftPM 공용)
public enum ServiceBundle {
  public static var bundle: Bundle {
    #if SWIFT_PACKAGE
    return .module
    #else
    return Bundle(for: BundleToken.self) // 이 타입이 Service 타깃에 포함되어야 함
    #endif
  }
  private final class BundleToken {}
}
