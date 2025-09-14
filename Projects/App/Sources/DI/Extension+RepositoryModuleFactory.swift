//
//  Extension+RepositoryModuleFactory.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation

import Core
import DiContainer
import Repository

extension RepositoryModuleFactory {
  public mutating func registerDefaultDefinitions() {
    let registerModuleCopy = registerModule

    definitions = {
      return [
        registerModuleCopy.bookListRepositoryImplModule,
        registerModuleCopy.summaryPersistenceRepositoryImplModule
      ]
    }()
  }
}
