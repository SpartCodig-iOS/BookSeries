//
//  JSONManager.swift
//  Service
//
//  Created by Wonji Suh  on 9/5/25.
//


import Foundation
import LogMacro


// MARK: - JSONManager
public actor JSONManager {
  public init() {}

   static let resourceURLCache = NSCache<NSString, NSURL>()

    nonisolated private static func cacheKey(
      bundle: Bundle, name: String, ext: String, subdir: String?
    ) -> NSString {
      "\(bundle.bundlePath)|\(subdir ?? "")|\(name).\(ext)" as NSString
    }

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
    fileName: String,
    ext: String? = nil,
    bundle: Bundle? = nil,
    subdirectory: String? = nil
  ) async throws -> T {
    let (name, ext) = normalize(fileName, preferExt: ext)
    let preferred = bundle ?? ServiceBundle.bundle

    var seen = Set<String>()
    let bundles: [Bundle] =
      ([preferred, Bundle(for: JSONManager.self), .main] + Bundle.allFrameworks + Bundle.allBundles)
        .compactMap { $0 }
        .filter { seen.insert($0.bundlePath).inserted }

    var tried: [String] = []
    for b in bundles {
      // ✅ 캐시 조회
      let key = cacheKey(bundle: b, name: name, ext: ext, subdir: subdirectory)
      if let cached = resourceURLCache.object(forKey: key) {
        let data = try Data(contentsOf: cached as URL, options: [.mappedIfSafe])
        return try await parse(type, from: data)
      }

      // ✅ 미스 시 검색 → 적중하면 캐시에 저장
      if let url = findResource(named: name, ext: ext, subdir: subdirectory, in: b) {
        resourceURLCache.setObject(url as NSURL, forKey: key)
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

