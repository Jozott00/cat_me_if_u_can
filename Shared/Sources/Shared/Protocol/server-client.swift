//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

/// Structure representing a game state update.

public struct ProtoUpdate: Codable {
    public let data: ProtoUpdateData  // The type of the update.

    public init(
        data: ProtoUpdateData
    ) {
        self.data = data
    }
}

public enum ProtoUpdateData: Codable {
    // FIXME: Are there any better names possible here?
    // game start   .. indicates start of round
    case gameStart(layout: ProtoGameLayout)
    // game end     .. indicates end of round
    case gameEnd(score: ProtoScoreBoard)
    // state update .. comes after each tick
    case gameState(state: ProtoGameState)

    // scoreboard   .. shows scores of all players
    case scoreboard(board: ProtoScoreBoard)
    // join ack     .. tells assigned id after joining lobby
    case joinAck(id: String) // TODO: evaluate more precise structure
    // lobby update .. comes if user joined or left the lobby
    case lobbyUpdate(users: [ProtoUser], gameRunning: Bool)
}

/// Structure representing the game state that changes frequently
public struct ProtoGameState: Codable {

    // tim changed let to var for testing, if not removed pls remove
    public var mice: [ProtoMouse]

    // tim changed let to var for testing, if not removed pls remove
    public var cats: [ProtoCat]

    public init(
        mice: [ProtoMouse],
        cats: [ProtoCat]
    ) {
        self.mice = mice
        self.cats = cats
    }
}

public struct ProtoScoreBoard: Codable {
    /// number of catched mice per cat/user
    public let scores: [ProtoCat: Int]

    /// number of mices that reached the destiniation
    public let miceMissed: Int
    /// number of mices that can still get catched
    public let miceLeft: Int

    /// duration of game since start in seconds
    public let gameDurationSec: Int

    public init(scores: [ProtoCat: Int], miceMissed: Int, miceLeft: Int, gameDurationSec: Int) {
        self.scores = scores
        self.miceMissed = miceMissed
        self.gameDurationSec = gameDurationSec
        self.miceLeft = miceLeft
    }
}

public struct ProtoUser: Codable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

/// Structure representing the game state that only changes every round
public struct ProtoGameLayout: Codable {

    // tim changed let to var for testing, if not removed pls remove
    public var exits: [ProtoExit]

    public init(
        exits: [ProtoExit]
    ) {
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

    public init(
        mouseID: String,
        position: Position,
        state: String
    ) {
        self.mouseID = mouseID
        self.position = position
        self.state = state
    }
}

public struct ProtoCat: Codable, Hashable {
    public let playerID: String
    public let position: Position
    public let name: String

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case position
        case name
    }

    public init(playerID: String, position: Position, name: String) {
        self.playerID = playerID
        self.position = position
        self.name = name
    }

    public static func == (lhs: ProtoCat, rhs: ProtoCat) -> Bool {
        return lhs.playerID == rhs.playerID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(playerID)
    }
}

public struct ProtoExit: Codable {
    public let exitID: String
    public let position: Position

    enum CodingKeys: String, CodingKey {
        case exitID = "exit_id"
        case position
    }

    public init(
        exitID: String,
        position: Position
    ) {
        self.exitID = exitID
        self.position = position
    }
}
