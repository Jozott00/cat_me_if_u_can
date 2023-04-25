//
//  WebSocketClient.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//

import Foundation
import Logging
import Shared

class WebsocketClient: WebSocketConnectionDelegate {
  let connection = WebSocketTaskConnection(url: URL(string: "ws://catme.dobodox.com/connect")!)
  /// Logger instance for `WebsocketClient`.
  private let log = Logger(label: "WebsocketClient")

  // TODO: Add a board state variable here
  // TODO: Make that board state variable shareable
  // TODO: make the payload parameterized
  // TODO: Write useful comments
  // TODO: optional have url as a config variable

  /// Starts a WS connection
  func start() {
    let connection = WebSocketTaskConnection(url: WS.wsConnectionURL)
    connection.delegate = self
    connection.connect()

    let payload = """
      {
          "timestamp": 168488694.712589,
          "body": {
              "action": {
                  "action": {
                      "data": {
                          "join":{
                              "username":"Tim2"
                          }
                      }
                  }
              }
          }
      }
      """
    connection.send(msg: payload)
  }
  func stop() {
    connection.disconnect()
  }
  func onConnected(connection: WebSocketConnection) {
    log.info("Connected")
  }

  func onDisconnected(connection: WebSocketConnection, error: Error?) {
    if let error = error {
      log.info("Disconnected with error: \(error)")
    }
    else {
      log.info("Disconnected normally")
    }
  }

  func onError(connection: WebSocketConnection, error: Error) {
    log.info("Web Socket connection error \(error)")
  }

  func onMessage(connection: WebSocketConnection, msg: String) {
    do {
      let data = msg.data(using: .utf8)!
      let decoder = JSONDecoder()
      let msg: ProtocolMsg = try decoder.decode(ProtocolMsg.self, from: data)
      log.info("\(msg.timestamp)")
      log.info("\(msg.body)")
      // TODO: handle update messages
      if case let .action(action: action) = msg.body {
        log.info("\(msg.body)")
      }
      else {
        log.info("error")
        let err = ProtoError(code: .genericError, message: "Type of message was not action.")
        //        await send(msg: err, to: user)
      }

    }
    catch {
      //      log.error("Error while handling incoming message: \(error.localizedDescription)")
    }
  }
}
