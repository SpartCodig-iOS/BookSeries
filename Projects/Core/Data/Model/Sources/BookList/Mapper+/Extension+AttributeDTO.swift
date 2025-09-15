//
//  Extension+AttributeDTO.swift
//  Model
//
//  Created by Wonji Suh  on 9/5/25.
//

import Foundation

public extension AttributesDTO {
  func toDomain() -> Book {
    return Book(
      title: title,
      author: author,
      pages: pages,
      image: image,
      releaseDate: releaseDate ?? "",
      dedication: dedication,
      summary: summary,
      wiki: wiki,
      chapters: chapters.map { $0.title }
    )
  }
}

public extension Array where Element == BookDatRespnseDTO {
  func toDomain() -> [Book] {
    map { $0.attributes.toDomain() }
  }
}
