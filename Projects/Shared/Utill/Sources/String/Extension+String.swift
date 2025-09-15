//
//  Extension+String.swift
//  Utill
//
//  Created by Wonji Suh  on 9/9/25.
//

import Foundation

public extension String {
  /// "yyyy-M-d" → "yyyy-MM-dd"로 0패딩 정규화
  func normalizedYMD() -> String {
    let parts = split(separator: "-")
    guard parts.count == 3 else { return self }
    let y = parts[0]
    let m = parts[1].count == 1 ? "0\(parts[1])" : String(parts[1])
    let d = parts[2].count == 1 ? "0\(parts[2])" : String(parts[2])
    return "\(y)-\(m)-\(d)"
  }

  func toLongUSDate(
    inputFormats: [String] = [
      "yyyy-MM-dd",   // 1997-06-26
      "yyyy-M-d",     // 2007-7-2
      "yyyy/MM/dd",   // 1997/06/26
      "yyyy.M.d"      // 1997.6.26
    ]
  ) -> String? {
    let posix = Locale(identifier: "en_US_POSIX")
    let gmt = TimeZone(secondsFromGMT: 0)!

    let out = DateFormatter()
    out.locale = posix
    out.timeZone = gmt
    out.dateFormat = "MMMM d, yyyy" // 예: June 26, 1997

    let df = DateFormatter()
    df.locale = posix
    df.timeZone = gmt

    for fmt in inputFormats {
      df.dateFormat = fmt
      if let date = df.date(from: self) {
        return out.string(from: date)
      }
    }
    return nil
  }

  /// 파싱 실패 시 원본 문자열을 그대로 반환하는 편의 메서드
  func toLongUSDateOrSelf() -> String {
    return toLongUSDate() ?? self
  }


  func truncated(to maxChars: Int, suffix: String = "…") -> String {
    guard count > maxChars else { return self }
    let end = index(startIndex, offsetBy: maxChars)
    return String(self[..<end]) + suffix
  }
}
