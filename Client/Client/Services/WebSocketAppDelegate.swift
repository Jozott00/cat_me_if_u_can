//
//  WebSocketAppDelegate.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//

import Foundation
import Shared

// TODO: add logger
// TODO: write useful comments
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
    do {
      let data = text.data(using: .utf8)!
      let decoder = JSONDecoder()
      let msg: ProtocolMsg = try decoder.decode(ProtocolMsg.self, from: data)
      print(msg.timestamp)
      print(msg.body)
      // TODO: handle update messages
      if case let .action(action: action) = msg.body {
        print(msg.body)
      }
      else {
        print("error")
        let err = ProtoError(code: .genericError, message: "Type of message was not action.")
        //        await send(msg: err, to: user)
      }

    }
    catch {
      //      log.error("Error while handling incoming message: \(error.localizedDescription)")
    }
  }
}
