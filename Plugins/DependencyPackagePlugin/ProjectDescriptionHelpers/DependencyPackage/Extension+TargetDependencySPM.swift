//
//  Extension+TargetDependencySPM.swift
//  DependencyPackagePlugin
//
//  Created by 서원지 on 4/19/24.
//

import ProjectDescription

public extension TargetDependency.SPM {
  static let asyncMoya = TargetDependency.external(name: "AsyncMoya", condition: .none)
  static let composableArchitecture = TargetDependency.external(name: "ComposableArchitecture", condition: .none)
  static let diContainer = TargetDependency.external(name: "DiContainer", condition: .none)
  static let snapKit = TargetDependency.external(name: "SnapKit", condition: .none)
  static let then = TargetDependency.external(name: "Then", condition: .none)
  static let pinLayout = TargetDependency.external(name: "PinLayout", condition: .none)
  static let flexLayout = TargetDependency.external(name: "FlexLayout", condition: .none)
  static let logMacro = TargetDependency.external(name: "LogMacro", condition: .none)
}
