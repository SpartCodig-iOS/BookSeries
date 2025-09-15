//
//  BookListUseCaseImpl.swift
//  UseCase
//
//  Created by Wonji Suh  on 9/8/25.
//

import DomainInterface
import Model
import Repository

import ComposableArchitecture
import DiContainer
import Foundation

public struct BookListUseCaseImpl: BookListInterface {

  private let repository: BookListInterface

  public init(repository: BookListInterface) {
    self.repository = repository
  }

  // MARK: - 전체  북  리스트 조회
  public func getBookList() async throws -> [Book] {
    return  try await repository.getBookList()
  }
}

extension DependencyContainer {
  var bookListInterface: BookListInterface? {
    resolve(BookListInterface.self)
  }
}

extension BookListUseCaseImpl: DependencyKey {

  public static var liveValue: BookListInterface = {
   let repository = UnifiedDI.register(\.bookListInterface) {
      BookListRepositoryImpl()
    }
    return BookListUseCaseImpl(repository: repository)
  }()

  public static var testValue: BookListInterface = DefaultBookListRepositoryImpl()
}

public extension DependencyValues {
  var bookListUseCase: BookListInterface {
    get { self[BookListUseCaseImpl.self] }
    set { self[BookListUseCaseImpl.self] = newValue }
  }
}


public extension RegisterModule {

  var bookListUseCaseImplModule: () -> Module {
    makeUseCaseWithRepository(
      BookListInterface.self,
      repositoryProtocol: BookListInterface.self,
      repositoryFallback: DefaultBookListRepositoryImpl()) { repo in
        BookListUseCaseImpl(repository: repo)
      }
  }

  var bookListModules: [() -> Module] {
    return interface(
      BookListInterface.self,
      repository: { BookListRepositoryImpl() },
      useCase: { repo in BookListUseCaseImpl(repository: repo) },
      fallback: { DefaultBookListRepositoryImpl() }
    )
  }

}
