//
//  Extension+RepositoryModuleFactory.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation

import Core
import DiContainer

extension RepositoryModuleFactory {
  public mutating func registerDefaultDefinitions() {
    let registerModuleCopy = registerModule

    repositoryDefinitions = {
      return [
        registerModuleCopy.bookListRepositoryImplModule
      ]
    }()
  }
}
