//
//  BookDisplayData.swift
//  Model
//
//  Created by Wonji Suh  on 9/10/25.
//

import Foundation

public struct BookDisplayData: Equatable {
  public let book: Book
  public let seriesNumber: Int
  public let totalSeries: Int
  public let isSummaryExpanded: Bool

  public init(
    book: Book,
    seriesNumber: Int,
    totalSeries: Int,
    isSummaryExpanded: Bool
  ) {
    self.book = book
    self.seriesNumber = seriesNumber
    self.totalSeries = totalSeries
    self.isSummaryExpanded = isSummaryExpanded
  }
}
