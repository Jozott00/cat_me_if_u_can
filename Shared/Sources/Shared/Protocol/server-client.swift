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
    public let mouseID: String
    public let position: Position
    public let state: String

    enum CodingKeys: String, CodingKey {
        case mouseID = "mouse_id"
        case position
        case state
    }

    public init(mouseID: String, position: Position, state: String) {
        self.mouseID = mouseID
        self.position = position
        self.state = state
    }
}

public struct ProtoCat: Codable {
    public let playerID: String
    public let position: Position

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case position
    }

    public init(playerID: String, position: Position) {
        self.playerID = playerID
        self.position = position
    }
}

public struct ProtoExit: Codable {
    public let exitID: String
    public let position: Position

    enum CodingKeys: String, CodingKey {
        case exitID = "exit_id"
        case position
    }

    public init(exitID: String, position: Position) {
        self.exitID = exitID
        self.position = position
    }
}
