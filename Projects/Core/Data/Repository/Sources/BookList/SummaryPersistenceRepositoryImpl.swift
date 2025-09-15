//
//  SummaryPersistenceRepository.swift
//  Repository
//
//  Created by Wonji Suh on 9/10/25.
//

import Foundation
import DomainInterface

@Observable
public final class SummaryPersistenceRepositoryImpl: SummaryPersistenceRepositoryInterface, Observable {
  private let userDefaults: UserDefaults

  public init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  public func loadSummaryExpanded(for title: String, author: String) -> Bool {
    let key = generateKey(for: title, author: author)
    return userDefaults.bool(forKey: key)
  }

  public func saveSummaryExpanded(_ expanded: Bool, for title: String, author: String) {
    let key = generateKey(for: title, author: author)
    userDefaults.set(expanded, forKey: key)
  }

  private func generateKey(for title: String, author: String) -> String {
    return "SummaryExpanded.\(title)|\(author)"
  }
}
