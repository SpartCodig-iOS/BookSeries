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
  
  private var storage: [String: Bool] = [:]
  private var loadCallCount = 0
  private var saveCallCount = 0
  
  public init() {
    setupMockData()
  }
  
  private func setupMockData() {
    storage["SummaryExpanded.클린 코드|로버트 C. 마틴"] = true
    storage["SummaryExpanded.이펙티브 자바|조슈아 블로크"] = false
    storage["SummaryExpanded.스위프트 프로그래밍|야곰"] = true
    storage["SummaryExpanded.디자인 패턴|GoF"] = false
    storage["SummaryExpanded.리팩토링|마틴 파울러"] = true
  }

  public func loadSummaryExpanded(for title: String, author: String) -> Bool {
    loadCallCount += 1
    let key = generateKey(for: title, author: author)
    return storage[key] ?? false
  }

  public func saveSummaryExpanded(_ expanded: Bool, for title: String, author: String) {
    saveCallCount += 1
    let key = generateKey(for: title, author: author)
    storage[key] = expanded
  }
  
  private func generateKey(for title: String, author: String) -> String {
    return "SummaryExpanded.\(title)|\(author)"
  }
  
  // MARK: - Test Helper Methods
  
  public func getLoadCallCount() -> Int {
    return loadCallCount
  }
  
  public func getSaveCallCount() -> Int {
    return saveCallCount
  }
  
  public func getAllStoredData() -> [String: Bool] {
    return storage
  }
  
  public func setStoredData(_ data: [String: Bool]) {
    storage = data
  }
  
  public func reset() {
    storage.removeAll()
    loadCallCount = 0
    saveCallCount = 0
    setupMockData()
  }
  
  public func clearStorage() {
    storage.removeAll()
  }
}
