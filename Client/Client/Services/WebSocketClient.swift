//
//  WebSocketClient.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//  Inspired by https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/AppDelegate.swift
//

import Foundation
import Logging
import Shared

class WebsocketClient: WebSocketConnectionDelegate {
  let connection = WebSocketTaskConnection(url: URL(string: "ws://catme.dobodox.com/connect")!)
  var gameData: GameData

  init(
    gameData: GameData
  ) {
    self.gameData = gameData
  }

  /// Logger instance for `WebsocketClient`.
  private let log = Logger(label: "WebsocketClient")

  // TODO: Add a board state variable here
  // TODO: Make that board state variable shareable

  /// Starts a WS connection
  func start(userName: String) {
    let connection = WebSocketTaskConnection(url: WS.wsConnectionURL)
    // realize delegate pattern by adding current instance to WS connection
    connection.delegate = self
    // establishes a connection to WS Server
    connection.connect()
    // Notifies the server that a player has joined the game
    let action: ProtoAction = ProtoAction(data: .join(username: userName))
    if let msg = action.toJSONString() {
      connection.send(msg: msg)
    }
    else {
      log.error("Error while trying to join a game")
    }

  }
  // stops the connection to the WS client
  func stop() {
    let action: ProtoAction = ProtoAction(data: .leave)
    if let msg = action.toJSONString() {
      connection.send(msg: msg)
      connection.disconnect()
    }
    else {
      log.error("Error while trying to leave a game")
    }
  }

  func onConnected(connection: WebSocketConnection) {
    log.info("Connected")
  }

  func onDisconnected(connection: WebSocketConnection, error: Error?) {
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

  func onMessage(connection: WebSocketConnection, msg: String) {

    if let protocolMsg = msg.toProtoMsg() {
      if case let .update(update) = protocolMsg.body {
        switch update.data {
          case let .gameLayout(layout):
            print("Game layout: \(layout)")
            DispatchQueue.main.async {
              self.gameData.gameLayout = layout
            }
          case let .gameState(state):
            DispatchQueue.main.async {
              self.gameData.gameState = state
            }
            print("Game state: \(state)")
          case let .joinAck(id):
            print("Join Acknowledgment: \(id)")
        }
      }
      else {
        log.error("The JSON does not contain an update.")
      }
    }
    else {
      log.error("Error decoding JSON string.")
    }
  }
}
