//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

/// Structure representing a game state update.
struct ProtoUpdate: Codable {
    let name: String // The name of the update.
    let gameState: ProtoGameState?
}

/// Structure representing the game state, including mice, cats, and exits.
struct ProtoGameState: Codable {
    let mice: [ProtoMouse]
    let cats: [ProtoCat]
    let exits: [ProtoExit]
}

// game elements

struct ProtoMouse: Codable {
    let mouseID: String
    let position: Position
    let state: String

    enum CodingKeys: String, CodingKey {
        case mouseID = "mouse_id"
        case position
        case state
    }
}

struct ProtoCat: Codable {
    let playerID: String
    let position: Position

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case position
    }
}

struct ProtoExit: Codable {
    let exitID: String
    let position: Position

    enum CodingKeys: String, CodingKey {
        case exitID = "exit_id"
        case position
    }
}
