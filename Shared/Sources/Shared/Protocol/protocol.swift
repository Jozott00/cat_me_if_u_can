//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

/// Enum representing the type of messages in the protocol: action, update, or error.
public enum ProtoMessageType: String, Codable {
    case action
    case update
    case error
}

/// Structure representing a protocol message for communication between the server and clients.
public struct ProtocolMsg: Codable {
    public let type: ProtoMessageType // The type of message: action, update, or error.
    public let timestamp: TimeInterval // Timestamp indicating when the message was created.
    public let action: ProtoAction? // The action performed by a user, if applicable.
    public let update: ProtoUpdate? // The game state update from the server, if applicable.
    public let error: ProtoError? // The error information, if applicable.

    public init(type: ProtoMessageType,
                timestamp: TimeInterval,
                action: ProtoAction? = nil,
                update: ProtoUpdate? = nil,
                error: ProtoError? = nil)
    {
        self.type = type
        self.timestamp = timestamp
        self.action = action
        self.update = update
        self.error = error
    }
}

// A ProtoBody is either ProtoAction, ProtoUpdate or ProtoError
public protocol ProtoBody {
    func createMsg() -> ProtocolMsg
}

extension ProtoAction: ProtoBody {
    public func createMsg() -> ProtocolMsg {
        ProtocolMsg(type: .action, timestamp: Date().timeIntervalSince1970, action: self)
    }
}

extension ProtoUpdate: ProtoBody {
    public func createMsg() -> ProtocolMsg {
        ProtocolMsg(type: .update, timestamp: Date().timeIntervalSince1970, update: self)
    }
}

extension ProtoError: ProtoBody {
    public func createMsg() -> ProtocolMsg {
        ProtocolMsg(type: .error, timestamp: Date().timeIntervalSince1970, error: self)
    }
}
