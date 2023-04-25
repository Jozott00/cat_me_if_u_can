//
//  WebSocketConnection.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import Foundation
// TODO: write useful comments
protocol WebSocketConnection {
  func send(text: String)
  func connect()
  func disconnect()
  var delegate: WebSocketConnectionDelegate? {
    get
    set
  }
}
