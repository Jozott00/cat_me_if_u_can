//
//  Configuration.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//  inspired from: https://designcode.io/swiftui-advanced-handbook-configuration-files-in-xcode
//

import Foundation

enum Configuration {
  enum Error: Swift.Error {
    case missingKey
    case invalidValue
  }
  static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
      throw Error.missingKey
    }

    switch object {
      case let value as T:
        return value
      case let string as String:
        guard let value = T(string) else { fallthrough }
        return value
      default:
        throw Error.invalidValue
    }
  }
}

enum WS {
  static var wsConnectionURL: URL {
      
    return try! URL(string: "ws://" + Configuration.value(for: "WS_HOST") + "/connect")!
  }
}
