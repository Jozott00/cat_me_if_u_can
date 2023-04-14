//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

public struct ProtoError: Codable {
    public let code: ProtoErrorType
    public let message: String

    public init(code: ProtoErrorType, message: String) {
        self.code = code
        self.message = message
    }
}

public enum ProtoErrorType: String, Codable {
    case genericError
}
