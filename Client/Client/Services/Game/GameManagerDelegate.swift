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
  let data: GameData
  init(
    data: GameData
  ) {
    self.data = data
  }

  func onConnected() {
    log.info("Connected")
  }

  func onDisconnected(error: Error?) {
    if let error = error {
      log.error("Disconnected with error: \(error)")
    }
    else {
      log.info("Disconnected normally")
    }
  }

  func onError(error: Error) {
    log.error("WS Error \(error.localizedDescription)")
  }

  func onMessage(msg: String) {
    if let protocolMsg = msg.toProtoMsg() {
      if case let .update(update) = protocolMsg.body {
        switch update.data {
          case let .gameLayout(layout):
            DispatchQueue.main.async {
              self.data.gameLayout = layout
            }
          case let .gameState(state):
            DispatchQueue.main.async {
              self.data.gameState = state
            }
          case let .joinAck(id):
            log.info("ack: \(id)")
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
}
