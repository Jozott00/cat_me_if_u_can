//
//  WebSocketConnectionDelegate.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//  Inspired by https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/AppDelegate.swift


import Foundation

/// Realizes the delegate Pattern for Websocket ConnectionTask
protocol WebSocketConnectionDelegate {
  /// Called after WS connects
  /// - Parameter connection: WS Connection
  func onConnected(connection: WebSocketConnection)
  /// Called after WS  voluntarly disconnects
  /// - Parameters:
  ///   - connection: WS connection
  ///   - error: Error, present when WS Connection produces an error while disconnnecting
  func onDisconnected(connection: WebSocketConnection, error: Error?)
  /// Called  after a WS method produces an error
  /// - Parameters:
  ///   - connection: WS connection
  ///   - error: Error, present when WS Connection produces an error while disconnnecting
  func onError(connection: WebSocketConnection, error: Error)
  /// Handles WS messages
  /// - Parameters:
  ///   - connection: WS connection
  ///   - msg: msg
  func onMessage(connection: WebSocketConnection, msg: String)
}
