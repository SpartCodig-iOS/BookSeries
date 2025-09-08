//
//  JSONParsingError.swift
//  Service
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation

// MARK: - JSON Parsing Errors
enum JSONParsingError: Error, LocalizedError {
  case invalidString
  case fileNotFound
  case invalidFormat
  case encodingFailed

  var errorDescription: String? {
    switch self {
    case .invalidString:
      return "유효하지 않은 JSON 문자열입니다."
    case .fileNotFound:
      return "JSON 파일을 찾을 수 없습니다."
    case .invalidFormat:
      return "JSON 형식이 올바르지 않습니다."
    case .encodingFailed:
      return "JSON 인코딩에 실패했습니다."
    }
  }
}
