//
//  WebSocketAppDelegate.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//

import Foundation

class WebSocketAppDelegate: WebSocketConnectionDelegate {
  func onConnected(connection: WebSocketConnection) {
    print("Connected")
  }

  func onDisconnected(connection: WebSocketConnection, error: Error?) {
    if let error = error {
      print("Disconnected with error: \(error)")
    }
    else {
      print("Disconnected normally")
    }
  }

  func onError(connection: WebSocketConnection, error: Error) {
    print("Web Socket connection error \(error)")
  }

  func onMessage(connection: WebSocketConnection, text: String) {
    print("Text message: \(text)")
  }

  func onMessage(connection: WebSocketConnection, data: Data) {
    print("Data message: \(data)")
  }
}
