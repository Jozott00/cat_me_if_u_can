//
//  WebSocketConnection.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import Foundation

protocol WebSocketConnection {
  func send(text: String)
  func send(data: Data)
  func connect()
  func disconnect()
  var delegate: WebSocketConnectionDelegate? {
    get
    set
  }
}
