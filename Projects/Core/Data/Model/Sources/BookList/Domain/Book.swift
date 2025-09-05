//
//  Book.swift
//  Model
//
//  Created by Wonji Suh  on 9/5/25.
//

import Foundation


public struct Book: Equatable {
    public let title: String
    public let author: String
    public let pages: Int
    public let releaseDate: String
    public let dedication: String?
    public let summary: String
    public let wiki: String
    public let chapters: [String]

  public init(
    title: String,
    author: String,
    pages: Int,
    releaseDate: String,
    dedication: String?,
    summary: String,
    wiki: String,
    chapters: [String]
  ) {
    self.title = title
    self.author = author
    self.pages = pages
    self.releaseDate = releaseDate
    self.dedication = dedication
    self.summary = summary
    self.wiki = wiki
    self.chapters = chapters
  }
}

