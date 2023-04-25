//
//  WebSocketConnectionDelegate.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import Foundation
/// Realizes the delegate Pattern for Websocket ConnectionTask
protocol WebSocketConnectionDelegate {
  func onConnected(connection: WebSocketConnection)
  func onDisconnected(connection: WebSocketConnection, error: Error?)
  func onError(connection: WebSocketConnection, error: Error)
  func onMessage(connection: WebSocketConnection, text: String)
}
