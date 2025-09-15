//
//  AppDelegate.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/5/25.
//

import UIKit
import DiContainer
import LogMacro

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


    DependencyContainer.bootstrapInTask { _ in
      await AppDIContainer.shared.registerDefaultDependencies()
    }

    UnifiedDI.enablePerformanceOptimization()

    Task {

      let loggingPlugin = LoggingPlugin()
      try await PluginManager.shared.register(loggingPlugin)

      let performancePlugin = PerformanceMonitoringPlugin(maxSamples: 50)
      let performace = PerformanceMonitoringPlugin()
      try await PluginManager.shared.register(performace)

      try await performancePlugin.activate()

      try AutoGraphGenerator.quickGenerate()

    }

    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }


  private func registerDependencies() {
    Task {
      await AppDIContainer.shared.registerDefaultDependencies()
    }
  }


}

