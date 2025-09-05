//
//  SceneDelegate.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/5/25.
//

import UIKit
import Presentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = ViewController()
    window.makeKeyAndVisible()
    self.window = window

  }
}


