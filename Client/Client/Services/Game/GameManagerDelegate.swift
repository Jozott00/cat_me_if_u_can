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
        case let .gameCharacterState(state):
          DispatchQueue.main.async {
            self.data.gameState = state
          }
        case let .joinAck(id):
          log.info("ack: \(id)")
          // Start tracking player movement
          KeyboardManager.start()
        case .lobbyUpdate(users: _, gameRunning: _):
          log.error("LobbyUpdate is not implemented")
        case .scoreboard(board: _):
          log.error("Scoreboard is not implemented")
        case .gameEnd(score: _):
          log.error("GameEnd is not implemented")
        }
      } else {
        log.error("The JSON does not contain an update: \(msg)")
      }
    } else {
      log.error("Error decoding JSON string.")
    }
  }
}
