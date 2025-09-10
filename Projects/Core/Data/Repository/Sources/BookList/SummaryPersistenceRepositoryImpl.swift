//
//  SummaryPersistenceRepository.swift
//  Repository
//
//  Created by Wonji Suh on 9/10/25.
//

import Foundation
import DomainInterface

public final class SummaryPersistenceRepositoryImpl: SummaryPersistenceRepositoryInterface {
  
  public init() {}
  
  public func loadSummaryExpanded(for title: String, author: String) -> Bool {
    let key = generateKey(for: title, author: author)
    return UserDefaults.standard.bool(forKey: key)
  }
  
  public func saveSummaryExpanded(_ expanded: Bool, for title: String, author: String) {
    let key = generateKey(for: title, author: author)
    UserDefaults.standard.set(expanded, forKey: key)
  }
  
  // MARK: - Private Methods
  
  private func generateKey(for title: String, author: String) -> String {
    return "SummaryExpanded.\(title)|\(author)"
  }
}
