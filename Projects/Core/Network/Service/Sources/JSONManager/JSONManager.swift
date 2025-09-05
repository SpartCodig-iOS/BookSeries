//
//  JSONManager.swift
//  Service
//
//  Created by Wonji Suh  on 9/5/25.
//


import Foundation
import LogMacro


// MARK: - JSONManager Actor
public actor JSONManager {
  public init() {}

  // MARK: - Core Parsing Methods

  public static func parse<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(type, from: data)
  }

  public static func parse<T: Decodable>(_ type: T.Type, from jsonString: String) async throws -> T {
    guard let data = jsonString.data(using: .utf8) else {
      throw JSONParsingError.invalidString
    }
    return try await parse(type, from: data)
  }

  /// 로컬 파일에서 JSON 파싱 (App → 기본: .main, SPM → 명시적으로 .module 전달)

  public static func parseFromFile<T: Decodable>(
    _ type: T.Type,
    fileName: String = "RoomListData",
    bundle: Bundle? = nil
  ) async throws -> T {
    // ✅ 우선순위: 넘겨준 bundle → 자기 모듈 번들 → 마지막으로 main
    let resolvedBundle: Bundle = bundle
    ?? Bundle(for: JSONManager.self)

    guard let url = resolvedBundle.url(forResource: fileName, withExtension: "json") else {
      throw JSONParsingError.fileNotFound
    }

    let data = try Data(contentsOf: url)
    return try await parse(type, from: data)
  }
}


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
