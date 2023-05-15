//
//  GameManager.swift
//  Client
//
//  Created by Paul Pinter on 26.04.23.
//

import Foundation
import Logging
import Shared

/// Responsible handling WS Messages concerning the game
class GameManagerDelegate: WebSocketDelegate {
    private let log = Logger(label: "GameManagerDelegate")
    let data: GameData = GameSession.data

    func onConnected() {
        log.info("Connected")
    }

    func onDisconnected() {
        log.info("Disconnected")
    }

    func onError(error: Error) {
        log.error("WS Error \(error.localizedDescription)")
    }

    func onMessage(msg: String) {
        if let protocolMsg = msg.toProtoMsg() {
            if case let .update(update) = protocolMsg.body {
                switch update.data {
                    case let .gameStart(layout):
                        DispatchQueue.main.async {
                            self.data.gameLayout = layout
                        }
                        // Start tracking player movement
                        KeyboardManager.start()
                    case let .gameCharacterState(state):
                        DispatchQueue.main.async {
                            self.data.gameState = state
                        }
                    case let .joinAck(id):
                        log.info("ack: \(id)")
                    case let .lobbyUpdate(users, gameRunning: _):
                        usersThatLeft(currentActiveUsers: users)
                            .forEach { u in log.info("\(u.name) with id \(u.id) left the game") }
                        usersThatJoined(currentActiveUsers: users)
                            .forEach { u in log.info("\(u.name) with id \(u.id) joined the game") }
                        DispatchQueue.main.async {
                            self.data.activeUsers = users
                        }
                    case let .scoreboard(board):
                        log.info("Received Scoreboard")
                        DispatchQueue.main.async {
                            self.data.scoreBoard = board

                        }
                    case .gameEnd(score: _):
                        log.info("Game End")
                        KeyboardManager.stop()
                        DispatchQueue.main.async {
                            self.data.gameState = nil
                        }
                }
            }
            else {
                log.error("The JSON does not contain an update: \(msg)")
            }
        }
        else {
            log.error("Error decoding JSON string.")
        }

    }

    /// The function returns the set difference of the stored users in self.data.active users and the given user array
    /// Semantically speaking the result are the users that newley joined
    private func usersThatJoined(currentActiveUsers: [ProtoUser]) -> [ProtoUser] {
        if let previousActiveUsers = self.data.activeUsers {
            return currentActiveUsers.filter { currentU in
                return !previousActiveUsers.contains(currentU)
            }
        }
        else {
            return currentActiveUsers
        }
    }

    /// The function returns the set difference of the the given user array and the stored users in self.data.active
    /// Semantically speaking the result are the that left
    private func usersThatLeft(currentActiveUsers: [ProtoUser]) -> [ProtoUser] {
        if let previousActiveUsers = self.data.activeUsers {
            return previousActiveUsers.filter { currentU in
                return !currentActiveUsers.contains(currentU)
            }
        }
        else {
            return []
        }
    }
}
