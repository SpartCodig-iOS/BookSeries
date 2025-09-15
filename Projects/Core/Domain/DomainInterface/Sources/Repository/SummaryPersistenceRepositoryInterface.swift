//
//  SummaryPersistenceRepositoryInterface.swift
//  DomainInterface
//
//  Created by Wonji Suh on 9/10/25.
//

import Foundation

public protocol SummaryPersistenceRepositoryInterface {
  /// 책 요약의 펼침 상태 로드
  func loadSummaryExpanded(for title: String, author: String) -> Bool
  
  /// 책 요약의 펼침 상태 저장
  func saveSummaryExpanded(_ expanded: Bool, for title: String, author: String)
}