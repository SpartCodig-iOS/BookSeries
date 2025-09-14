//
//  Extension+AppDIContainer.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation
import DiContainer

extension AppDIContainer {
  func registerDefaultDependencies() async {
    await registerDependencies { container in
      // Repository 먼저 등록
      let factory = ModuleFactoryManager()

      await factory.registerAll(to: container)

    }
  }
}

