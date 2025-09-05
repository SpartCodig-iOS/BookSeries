//
//  BookDTO.swift
//  Model
//
//  Created by Wonji Suh  on 9/5/25.
//

import Foundation

public struct BookDTO: Decodable, Sendable {
  public let data: [BookDatRespnseDTO]
}

public struct BookDatRespnseDTO: Decodable, Sendable {
  let attributes: AttributesDTO
}

public struct AttributesDTO: Decodable, Sendable {
  let title: String
  let author: String
  let pages: Int
  let releaseDate: String?
  let dedication: String?
  let summary: String
  let wiki: String
  let chapters: [ChapterDTO]
  
  enum CodingKeys: String, CodingKey {
    case title, author, pages, dedication, summary, wiki, chapters
    case releaseDate = "release_date"
  }
}

struct ChapterDTO: Decodable, Sendable {
   let title: String
}

