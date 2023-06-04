//
//  GameSession.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//  Inspired by https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/AppDelegate.swift
//

import Foundation
import Logging
import Shared

/// Responsible for controlling the game flow
class GameSession {
  static private let connection = WebSocketClient(url: WSConfig.connectionURL)
  /// Logger instance for `WebsocketClient`.
  static private let log = Logger(label: "GameSession")
  static let data = GameData()

  /// Establishes  a WS connection
  ///  Does nothing if a connection has already been established
  static func join(userName: String) {
    if !connection.isConnected {
      // realize delegate pattern by adding current instance to WS connection
      connection.delegate = GameManagerDelegate()
      // establishes a connection to WS Server
      connection.connect()
      // Notifies the server that a player has joined the game
      let action: ProtoAction = ProtoAction(data: .join(username: userName))
      connection.send(action: action)
    } else {
      log.info("Did dont reconnected since there is an active connection")
    }
  }
  ///  Starts a game session
  ///  Does nothing if the game has already started
  static func gameStart() {
    let action: ProtoAction = ProtoAction(data: .startGame)
    connection.send(action: action)
  }
  /// stops the connection to the WS client
  /// does nothing if the client is not connected to the server
  static func stop() {
    if connection.isConnected {
      KeyboardManager.stop()
      KeyboardManager.endableAlertToneAndKeyboardInput()
      let action: ProtoAction = ProtoAction(data: .leave)
      connection.send(action: action)
      connection.disconnect()
    } else {
      log.info("Did not discont as the game has not started yet")
    }
  }
  /// sends the move action to the WS client
  /// does nothing if the client is not connected
  static func move(direction: ProtoDirection) {
    if connection.isConnected {
      let action: ProtoAction = ProtoAction(data: ProtoActionData.move(direction: direction))
      connection.send(action: action)
    } else {
      log.error("Did not move since the game has not started yet")
    }
  }
}
