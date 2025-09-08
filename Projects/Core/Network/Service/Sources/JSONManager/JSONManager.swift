//
//  JSONManager.swift
//  Service
//
//  Created by Wonji Suh  on 9/5/25.
//


import Foundation
import LogMacro


import Foundation

// MARK: - JSONManager
public actor JSONManager {
  public init() {}

  // MARK: - Core Parsing Methods
  public static func parse<T: Decodable, Input: JSONInput>(
      _ type: T.Type,
      from input: Input
    ) async throws -> T {
      let data = try input.toData()
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(T.self, from: data)
    }

  /// 로컬 JSON 로드 (Tuist/멀티모듈/SwiftPM 모두 대응)
  public static func parseFromFile<T: Decodable>(
    _ type: T.Type,
    fileName: String,               // "BookListData" 또는 "BookListData.json"
    ext: String? = nil,             // 미지정 시 자동 "json"
    bundle: Bundle? = nil,          // 우선 번들(기본: ServiceBundle.bundle)
    subdirectory: String? = nil     // 리소스가 폴더에 있을 때
  ) async throws -> T {
    let (name, ext) = normalize(fileName, preferExt: ext)
    let preferred = bundle ?? ServiceBundle.bundle

    // 번들 후보군(중복 제거 + 탐색 순서 보장)
    var seen = Set<String>()
    let bundles: [Bundle] =
      ([preferred, Bundle(for: JSONManager.self), .main] + Bundle.allFrameworks + Bundle.allBundles)
        .compactMap { $0 }
        .filter { seen.insert($0.bundlePath).inserted }

    var tried: [String] = []
    for b in bundles {
      if let url = findResource(named: name, ext: ext, subdir: subdirectory, in: b) {
        let data = try Data(contentsOf: url, options: [.mappedIfSafe])
        return try await parse(type, from: data)
      }
      tried.append("• \(b.bundlePath) —")
    }

    throw JSONFileLookupError.fileNotFound(name: name, ext: ext, tried: tried)
  }

  // MARK: - Helpers (private)
  private static func normalize(_ fileName: String, preferExt: String?) -> (String, String) {
    let ns = fileName as NSString
    let hasExt = !ns.pathExtension.isEmpty
    let base = hasExt ? ns.deletingPathExtension : fileName
    let ext  = preferExt ?? (hasExt ? ns.pathExtension : "json")
    return (base, ext)
  }

  private static func findResource(
    named: String,
    ext: String,
    subdir: String?,
    in bundle: Bundle
  ) -> URL? {
    // 1) 번들 직검색
    if let url = bundle.url(forResource: named, withExtension: ext, subdirectory: subdir) {
      return url
    }
    // 2) 하위 .bundle 전부 순회(깊이 제한 X)
    guard let resURL = bundle.resourceURL,
          let it = FileManager.default.enumerator(at: resURL, includingPropertiesForKeys: nil)
    else { return nil }

    for case let url as URL in it where url.pathExtension == "bundle" {
      if let nested = Bundle(url: url),
         let found = nested.url(forResource: named, withExtension: ext, subdirectory: subdir) {
        return found
      }
    }
    return nil
  }
}

