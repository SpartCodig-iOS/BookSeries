//
//  BookListRepositoryImpl.swift
//  Repository
//
//  Created by Wonji Suh  on 9/8/25.
//

import Combine
import Observation

import DomainInterface
import Model
import Service
import Foundation
import DiContainer


@Observable
public final class BookListRepositoryImpl: BookListInterface {

  public init() {}

// MARK: -  전체 북리스트 조회
  public func getBookList() async throws -> [Book] {
    let bookData = try await JSONManager.parseFromFile(
      BookDTO.self,
      fileName: "BookListData",          // 실제 파일명 확실히
      bundle: ServiceBundle.bundle
    )
    return bookData.data.toDomain()
  }
}

