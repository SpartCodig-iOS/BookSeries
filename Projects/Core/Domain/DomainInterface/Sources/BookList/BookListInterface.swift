//
//  BookListInterface.swift
//  DomainInterface
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation
import Model

public protocol BookListInterface {
  func getBookList() async throws -> [Book]
}
