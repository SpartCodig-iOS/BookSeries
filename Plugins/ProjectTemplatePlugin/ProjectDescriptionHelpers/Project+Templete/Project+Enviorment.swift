//
//  Project+Enviorment.swift
//  MyPlugin
//
//  Created by 서원지 on 1/6/24.
//

import Foundation
import ProjectDescription

public extension Project {
  enum Environment {
    public static let appName = "BookSeries"
    public static let appStageName = "BookSeries-Stage"
    public static let appProdName = "BookSeries-Prod"
    public static let appDevName = "BookSeries-Dev"
    public static let deploymentTarget : ProjectDescription.DeploymentTargets = .iOS("17.0")
    public static let deploymentDestination: ProjectDescription.Destinations = [.iPhone]
    public static let organizationTeamId = "N94CS4N6VR"
    public static let bundlePrefix = "io.Roy.BookSeries"
    public static let appVersion = "1.0.0"
    public static let mainBundleId = "io.Roy.BookSeries"
  }
}
