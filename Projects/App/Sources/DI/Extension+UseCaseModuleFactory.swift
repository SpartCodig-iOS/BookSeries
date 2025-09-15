//
//  Extension+UseCaseModuleFactory.swift
//  BookSeries
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation

import Core
import DiContainer

extension UseCaseModuleFactory {
  public mutating func registerDefaultDefinitions() {
    let register = registerModule
    
    definitions = {
      return [
        register.bookListUseCaseImplModule,
        register.summaryPersistenceUseCaseImplModule,
      ]
    }()
  }
}

extension ScopeModuleFactory {
  public mutating func registerDefaultDefinitions() {
    let register = registerModule
    
    definitions = {
      return [
        // UseCase만 등록 (Repository는 RepositoryModuleFactory에서 등록)
        register.bookListUseCaseImplModule,
        register.summaryPersistenceUseCaseImplModule,
      ]
    }()
  }
}


extension ModuleFactoryManager {
      mutating func registerDefaultDependencies() {
          // Repository
        repositoryFactory.registerDefaultDefinitions()


        useCaseFactory.registerDefaultDefinitions()

        scopeFactory.registerDefaultDefinitions()

      }
  }
