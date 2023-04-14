//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

/// Structure representing a game state update.
public struct ProtoUpdate: Codable {
    public let type: ProtoUpdateType // The type of the update.
    public let gameState: ProtoGameState?

    public init(type: ProtoUpdateType, gameState: ProtoGameState? = nil) {
        self.type = type
        self.gameState = gameState
    }
}

public enum ProtoUpdateType: String, Codable {
    case gameState
    case ack
}

/// Structure representing the game state, including mice, cats, and exits.
public struct ProtoGameState: Codable {
    let mice: [ProtoMouse]
    let cats: [ProtoCat]
    let exits: [ProtoExit]
}

// game elements

public struct ProtoMouse: Codable {
    let mouseID: String
    let position: Position
    let state: String

    enum CodingKeys: String, CodingKey {
        case mouseID = "mouse_id"
        case position
        case state
    }
}

public struct ProtoCat: Codable {
    let playerID: String
    let position: Position

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case position
    }
}

public struct ProtoExit: Codable {
    let exitID: String
    let position: Position

    enum CodingKeys: String, CodingKey {
        case exitID = "exit_id"
        case position
    }
}
