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
  public var useCaseDefinitions: [() -> Module] {
    return [
      registerModule.bookListUseCaseImplModule
    ]
  }
}
