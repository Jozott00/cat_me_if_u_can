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
  ///  Does nothing if a connection has already been established
  func start(userName: String, data: GameData) {
    if !connection.isConnected {
      // realize delegate pattern by adding current instance to WS connection
      connection.delegate = GameManagerDelegate(data: data)
      // establishes a connection to WS Server
      connection.connect()
      // Notifies the server that a player has joined the game
      let action: ProtoAction = ProtoAction(data: .join(username: userName))
      connection.send(action: action)
    }
    else {
      log.info("Did dont reconnected since there is an active connection")
    }
  }
  /// stops the connection to the WS client
  /// does nothing if the client is not connected to the server
  func stop() {
    if connection.isConnected {
      let action: ProtoAction = ProtoAction(data: .leave)
      connection.send(action: action)
      connection.disconnect()
    }
    else {
      log.info("Did not discont as the game has not started yet")
    }
  }
  /// sends the move action to the WS client
  /// does nothing if the client is not connected
  func move(direction: ProtoDirection) {
    if connection.isConnected {
      let action: ProtoAction = ProtoAction(data: ProtoActionData.move(direction: direction))
      connection.send(action: action)
    }
    else {
      log.error("Did not move since the game has not started yet")
    }
  }
}
