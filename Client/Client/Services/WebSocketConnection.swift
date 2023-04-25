//
//  WebSocketConnection.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//  Inspired by https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/WebSocketConnection.swift

import Foundation

protocol WebSocketConnection {
  /// Send plain text message to the WS Server
  /// - Parameter msg: msg the message to be send
  func send(msg: String)
  /// Connnects WS to Server
  func connect()
  /// Disconnects WS from Server
  func disconnect()
  /// Delegate object to realize delagate Pattern
  var delegate: WebSocketConnectionDelegate? {
    get
    set
  }
}
