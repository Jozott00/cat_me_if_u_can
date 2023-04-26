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

/// Responsible for controlling the game flow
class GameSession: ObservableObject {
  private let connection = WebSocketClient(url: WSConfig.connectionURL)
  /// Logger instance for `WebsocketClient`.
  private let log = Logger(label: "GameSession")

  /// Starts a WS connection
  func start(userName: String, data: GameData) {
    // realize delegate pattern by adding current instance to WS connection
    connection.delegate = GameManagerDelegate(data: data)
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
}
