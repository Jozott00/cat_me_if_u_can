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
    case gameCharacterState(state: ProtoGameState)

    // scoreboard   .. shows scores of all players
    case scoreboard(board: ProtoScoreBoard)
    // join ack     .. tells assigned id after joining lobby
    case joinAck(id: String)  // TODO: evaluate more precise structure
    // lobby update .. comes if user joined or left the lobby
    case lobbyUpdate(users: [ProtoUser], gameRunning: Bool)
}

/// Structure representing the game state that changes frequently
public struct ProtoGameState: Codable, Equatable {
    public var mice: [ProtoMouse]
    public var cats: [ProtoCat]

    public static func == (lhs: ProtoGameState, rhs: ProtoGameState) -> Bool {
        for mouse in lhs.mice {
            if rhs.mice.first(where: { $0 == mouse }) == nil {
                return false
            }
        }
        for cat in lhs.cats {
            if rhs.cats.first(where: { $0 == cat }) == nil {
                return false
            }
        }
        return true
    }

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

    public init(
        scores: [ProtoCat: Int],
        miceMissed: Int,
        miceLeft: Int,
        gameDurationSec: Int
    ) {
        self.scores = scores
        self.miceMissed = miceMissed
        self.gameDurationSec = gameDurationSec
        self.miceLeft = miceLeft
    }
}

public struct ProtoUser: Codable, Equatable {
    public let id: String
    public let name: String

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public init(
        id: String,
        name: String
    ) {
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

public struct ProtoMouse: Codable, Equatable {
    public let mouseID: String
    public let position: Position
    public let state: ProtoMouseState
    public var stateDescription: String {
        switch state {
            case .alive:
                return "🐭"
            case .dead:
                return "💀"
            case .hidden:
                return "👻"
        }
    }

    public static func == (lhs: ProtoMouse, rhs: ProtoMouse) -> Bool {
        return lhs.mouseID == rhs.mouseID && lhs.position == rhs.position && lhs.state == rhs.state
    }

    enum CodingKeys: String, CodingKey {
        case mouseID = "mouse_id"
        case position
        case state
    }

    public enum ProtoMouseState: Codable, Equatable {
        case alive
        case dead
        case hidden
    }

    public init(
        mouseID: String,
        position: Position,
        state: ProtoMouseState
    ) {
        self.mouseID = mouseID
        self.position = position
        self.state = state
    }
}

public struct ProtoCat: Codable, Hashable, Equatable {
    public let playerID: String
    public let position: Position
    public let name: String

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case position
        case name
    }

    public static func == (lhs: ProtoCat, rhs: ProtoCat) -> Bool {
        return lhs.playerID == rhs.playerID && lhs.position == rhs.position
    }

    /*public static func == (lhs: ProtoCat, rhs: ProtoCat) -> Bool {
        return lhs.playerID == rhs.playerID
    }*/

    public init(
        playerID: String,
        position: Position,
        name: String
    ) {
        self.playerID = playerID
        self.position = position
        self.name = name
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
