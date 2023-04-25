//
//  WebSocketClient.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//

import Foundation

class WebsocketClient {
  let connection = WebSocketTaskConnection(url: URL(string: "ws://catme.dobodox.com/connect")!)
  // TODO: Add a board state variable here
  // TODO: Make that board state variable shareable
  // TODO: Combine Client with delagate
  // TODO: make the payload parameterized
  // TODO: Write useful comments
  // TODO: optional have url as a config variable

  func start() {
    let connection = WebSocketTaskConnection(url: URL(string: "ws://catme.dobodox.com/connect")!)
    connection.delegate = WebSocketAppDelegate()
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
    connection.send(text: payload)
  }
  func stop() {
    connection.disconnect()
  }
}
