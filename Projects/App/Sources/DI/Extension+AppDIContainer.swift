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
      self.repositoryFactory.registerDefaultDefinitions()
      let repositoryFactory = self.repositoryFactory
      let useCaseFactory = self.useCaseFactory

      await repositoryFactory.makeAllModules().asyncForEach { module in
        await container.register(module)
      }

      await useCaseFactory.makeAllModules().asyncForEach { module in
        await container.register(module)
      }
    }
  }
}

