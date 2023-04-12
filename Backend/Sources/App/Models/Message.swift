//
//  File.swift
//
//
//  Created by Johannes Zottele on 21.03.23.
//

import Foundation

struct ProtocolMessage: Codable {
    let type: ProtocolMessageType
    let failure: ProtocolFailure?
    let operation: ProtocolOperation?
}

enum ProtocolMessageType: String, Codable {
    case failure
    case operation
}

struct ProtocolFailure: Codable {
    let code: Int
    let msg: String
}

struct ProtocolOperation: Codable {
    let operation: ProtocolOperationType
    let position: ProtocolOperationPosition
}

enum ProtocolOperationType: String, Codable {
    case move
    case hit
}

struct ProtocolOperationPosition: Codable {
    let x: Int
    let y: Int
}
