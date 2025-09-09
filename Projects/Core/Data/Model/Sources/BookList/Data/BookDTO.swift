//
//  BookDTO.swift
//  Model
//
//  Created by Wonji Suh  on 9/5/25.
//

import Foundation
import Utill

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
  let image: String
  let chapters: [ChapterDTO]

  private enum CodingKeys: String, CodingKey {
    case title, author, pages, dedication, summary, wiki, chapters, image
    case release_date                      // 정상 snake_case
    case releaseDateCamel = "releaseDate"  // camelCase 변형
    case released_date = "released_date"   // 변형/오타 대비
    case reasle_date = "reasle_date"       // 오타 대비
  }

  // releaseDate로 인정할 키 우선순위
  private static let releaseDateKeys: [CodingKeys] = [
    .release_date, .releaseDateCamel, .released_date, .reasle_date
  ]

  public init(from decoder: Decoder) throws {
    let codingKey = try decoder.container(keyedBy: CodingKeys.self)

    title       = try codingKey.decode(String.self, forKey: .title)
    author      = try codingKey.decode(String.self, forKey: .author)
    pages       = try codingKey.decode(Int.self,    forKey: .pages)
    dedication  = try codingKey.decodeIfPresent(String.self, forKey: .dedication)
    summary     = try codingKey.decode(String.self, forKey: .summary)
    wiki        = try codingKey.decode(String.self, forKey: .wiki)
    chapters    = try codingKey.decode([ChapterDTO].self, forKey: .chapters)
    image        =  try codingKey.decode(String.self, forKey: .image)

    let raw = try codingKey.decodeFirstIfPresent(String.self, for: Self.releaseDateKeys)
    releaseDate = raw?.normalizedYMD()  // "yyyy-M-d" → "yyyy-MM-dd"
  }
}

// MARK: - Helpers
struct ChapterDTO: Decodable, Sendable {
   let title: String
}

private extension KeyedDecodingContainer {
  /// 주어진 키 배열에서 **처음으로 존재하는** 키의 값을 디코딩
  func decodeFirstIfPresent<T: Decodable>(_ type: T.Type, for keys: [K]) throws -> T? {
    for key in keys where contains(key) {
      return try decodeIfPresent(type, forKey: key)
    }
    return nil
  }
}

