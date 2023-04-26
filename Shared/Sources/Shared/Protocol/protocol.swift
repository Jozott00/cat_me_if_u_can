//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

/// Enum representing the type of messages in the protocol: action, update, or error.
public enum ProtoMessageBody: Codable {
    case action(action: ProtoAction)
    case update(update: ProtoUpdate)
    case error(error: ProtoError)
}

/// Structure representing a protocol message for communication between the server and clients.
public struct ProtocolMsg: Codable {
    public let body: ProtoMessageBody // The type of message: action, update, or error.
    public let timestamp: TimeInterval // Timestamp indicating when the message was created.

    public init(type: ProtoMessageBody,
                timestamp: TimeInterval)
    {
        self.body = type
        self.timestamp = timestamp
    }
}

// A ProtoBody is either ProtoAction, ProtoUpdate or ProtoError
public protocol ProtoBody {
    func createMsg() -> ProtocolMsg
}

extension ProtoAction: ProtoBody {
    public func createMsg() -> ProtocolMsg {
        ProtocolMsg(type: .action(action: self), timestamp: Date().timeIntervalSince1970)
    }
}

extension ProtoUpdate: ProtoBody {
    public func createMsg() -> ProtocolMsg {
        ProtocolMsg(type: .update(update: self), timestamp: Date().timeIntervalSince1970)
    }
}

extension ProtoError: ProtoBody {
    public func createMsg() -> ProtocolMsg {
        ProtocolMsg(type: .error(error: self), timestamp: Date().timeIntervalSince1970)
    }
}

extension ProtoBody {
    public func toJSONString() -> String? {
        let msg = self.createMsg()

        do {
            let json = try JSONEncoder().encode(msg)
            return String(data: json, encoding: .utf8)
        }
        catch {
            return nil
        }
    }
}

extension String {
    public func toProtoMsg() -> ProtocolMsg? {
        let data = self.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let msg = try decoder.decode(ProtocolMsg.self, from: data)
            return msg
        }
        catch {
            return nil
        }
    }
}
