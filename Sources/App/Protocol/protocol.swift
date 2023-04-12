//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

/// Enum representing the type of messages in the protocol: action, update, or error.
enum ProtoMessageType: String, Codable {
    case action
    case update
    case error
}

/// Structure representing a protocol message for communication between the server and clients.
struct ProtocolMsg: Codable {
    let type: ProtoMessageType // The type of message: action, update, or error.
    let timestamp: TimeInterval // Timestamp indicating when the message was created.
    let playerID: String? // The player's unique identifier, if applicable.
    let action: ProtoAction? // The action performed by a user, if applicable.
    let gameState: ProtoUpdate? // The game state update from the server, if applicable.
    let error: ProtoError? // The error information, if applicable.

    // CodingKeys for custom key names in the JSON representation.
    enum CodingKeys: String, CodingKey {
        case type
        case timestamp
        case playerID = "player_id"
        case action
        case gameState = "game_state"
        case error
    }
}
