//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

/// Structure representing a game state update.

public struct ProtoUpdate: Codable {
    public let data: ProtoUpdateData // The type of the update.

    public init(data: ProtoUpdateData) {
        self.data = data
    }
}

public enum ProtoUpdateData: Codable {
    case ack
    case gameState(state: ProtoGameState)
}

/// Structure representing the game state, including mice, cats, and exits.
public struct ProtoGameState: Codable {
    public let mice: [ProtoMouse]
    public let cats: [ProtoCat]
    public let exits: [ProtoExit]

    public init(mice: [ProtoMouse], cats: [ProtoCat], exits: [ProtoExit]) {
        self.mice = mice
        self.cats = cats
        self.exits = exits
    }
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
