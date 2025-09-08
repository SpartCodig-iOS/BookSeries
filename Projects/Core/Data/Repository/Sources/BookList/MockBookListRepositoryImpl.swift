//
//  DefaultBookListRepositoryImpl.swift
//  Repository
//
//  Created by Wonji Suh  on 9/8/25.
//

import DomainInterface
import Model

final public class DefaultBookListRepositoryImpl: BookListInterface {
  public init() {}

  public func getBookList() async throws -> [Book] {
    return []
  }
}
