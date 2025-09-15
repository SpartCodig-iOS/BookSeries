//
//  SummaryPersistenceUseCaseImpl.swift
//  UseCase
//
//  Created by Wonji Suh  on 9/10/25.
//

import DomainInterface
import Repository

import ComposableArchitecture
import DiContainer

public struct SummaryPersistenceUseCaseImpl: SummaryPersistenceRepositoryInterface {
  
  private let repository: SummaryPersistenceRepositoryInterface

  public init(repository: SummaryPersistenceRepositoryInterface) {
    self.repository = repository
  }


  public func loadSummaryExpanded(for title: String, author: String) -> Bool {
    repository.loadSummaryExpanded(for: title, author: author)
  }

  public func saveSummaryExpanded(_ expanded: Bool, for title: String, author: String) {
    repository.saveSummaryExpanded(expanded, for: title, author: author)
  }
}

extension DependencyContainer {
  var summaryPersistenceInterface: SummaryPersistenceRepositoryInterface? {
    resolve(SummaryPersistenceRepositoryInterface.self)
  }
}

extension SummaryPersistenceUseCaseImpl: DependencyKey {

  public static var liveValue: SummaryPersistenceRepositoryInterface = {
    let repository = UnifiedDI.register(\.summaryPersistenceInterface) {
      SummaryPersistenceRepositoryImpl()
    }
    return SummaryPersistenceUseCaseImpl(repository: repository)
  }()

  public static var testValue: SummaryPersistenceRepositoryInterface = DefaultSummaryPersistenceRepository()
}

public extension DependencyValues {
  var summaryPersistenceUseCase: SummaryPersistenceRepositoryInterface {
    get { self[SummaryPersistenceUseCaseImpl.self] }
    set { self[SummaryPersistenceUseCaseImpl.self] = newValue }
  }
}


public extension RegisterModule {

  var summaryPersistenceUseCaseImplModule: () -> Module {
    makeUseCaseWithRepository(
      SummaryPersistenceUseCaseImpl.self,
      repositoryProtocol: SummaryPersistenceRepositoryInterface.self,
      repositoryFallback: DefaultSummaryPersistenceRepository(),
      factory: { repo in
        SummaryPersistenceUseCaseImpl(repository: repo)
      }
    )
  }


  var summaryPersistenceRepositoryImplModule: () -> Module {
    makeDependency(SummaryPersistenceRepositoryInterface.self) {
      SummaryPersistenceRepositoryImpl()
    }
  }
}
