//
//  JSONInput.swift
//  Service
//
//  Created by Wonji Suh  on 9/8/25.
//

import Foundation

public protocol JSONInput {
  func toData() throws -> Data
}

extension Data: JSONInput {
  public func toData() throws -> Data { self }
}

extension String: JSONInput {
  public func toData() throws -> Data {
    guard let data = self.data(using: .utf8) else { throw JSONParsingError.invalidString }
    return data
  }
}
