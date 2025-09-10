//
//  DefaultSummaryPersistenceRepository.swift
//  Repository
//
//  Created by Wonji Suh  on 9/10/25.
//

import DomainInterface
import Model
import Combine

public final class DefaultSummaryPersistenceRepository: SummaryPersistenceRepositoryInterface {
  public init() {

  }


  public func loadSummaryExpanded(for title: String, author: String) -> Bool {
    return false
  }

  public func saveSummaryExpanded(_ expanded: Bool, for title: String, author: String) {

  }
}
