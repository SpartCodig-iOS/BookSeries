//
//  JSONFileLookupError.swift
//  Service
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation

// MARK: - Detail error with lookup log
enum JSONFileLookupError: LocalizedError {
  case fileNotFound(name: String, ext: String, tried: [String])
  var errorDescription: String? {
    switch self {
    case let .fileNotFound(name, ext, tried):
      return "파일을 찾을 수 없습니다: \(name).\(ext)\n🔎 검색 로그:\n" + tried.joined(separator: "\n")
    }
  }
}
