//
//  WebSocketConnectionDelegate.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//  Inspired by https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/AppDelegate.swift

import Foundation

/// Realizes the delegate Pattern for Websocket ConnectionTask
protocol WebSocketDelegate {
  /// Called after WS connects
  func onConnected()
  /// Called after WS  voluntarly disconnects
  /// - Parameters:
  ///   - error: Error, present when WS Connection produces an error while disconnnecting
  func onDisconnected(error: Error?)
  /// Called  after a WS method produces an error
  /// - Parameters:
  ///   - error: Error, present when WS Connection produces an error while disconnnecting
  func onError(error: Error)
  /// Handles WS messages
  /// - Parameters:
  ///   - msg: msg
  func onMessage(msg: String)
}
