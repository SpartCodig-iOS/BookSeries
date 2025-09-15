//
//  SceneDelegate.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/5/25.
//

import UIKit
import Presentation
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: windowScene)
    let appStore = Store(initialState: AppReducer.State()) {
      AppReducer()
        ._printChanges()
    }

    let rootVC = AppRootViewController(store: appStore)

    window.rootViewController = rootVC
    window.makeKeyAndVisible()
    self.window = window

  }
}


