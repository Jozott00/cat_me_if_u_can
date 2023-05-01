//
//  WebSocketTaskConnection.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//  Inspired by https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/WebSocketConnection.swift

import Foundation
import Shared

protocol WebSocketConnection {
  /// Send plain text message to the WS Server
  /// - Parameter msg: msg the message to be send
  func send(action: ProtoAction)
  /// Connnects WS to Server
  func connect()
  /// Disconnects WS from Server
  func disconnect()
  /// Delegate object to realize delagate Pattern
  var delegate: WebSocketDelegate? {
    get
    set
  }
}

class WebSocketClient: NSObject, WebSocketConnection, URLSessionWebSocketDelegate {

  var delegate: WebSocketDelegate?
  var webSocketTask: URLSessionWebSocketTask?
  var urlSession: URLSession!
  let delegateQueue = OperationQueue()
  var isConnected = false
  var url: URL
  enum WsError: Error {
    // Throw when WS experiences a state that is not supported
    case notSupported
    case failedToConvertActionToJSON
  }

  init(
    url: URL
  ) {
    self.url = url
    super.init()
    urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
  }

  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didOpenWithProtocol protocol: String?
  ) {
    // called after webSocketTask.resume()
    self.delegate?.onConnected()
    listen()
  }

  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
    reason: Data?
  ) {
    // called after webSocketTask.cancel()
    self.delegate?.onDisconnected()
  }

  func connect() {
    if !isConnected {
      isConnected = true
      // create a new instance if it doesn't exist
      webSocketTask = urlSession.webSocketTask(with: self.url)
      webSocketTask?.resume()
    }
  }
  func disconnect() {
    if isConnected {
      isConnected = false
      webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
  }
  func send(action: ProtoAction) {
    // sends a plain texst message
    if let msg = action.toJSONString() {
      webSocketTask?
        .send(URLSessionWebSocketTask.Message.string(msg)) { error in
          if let error = error {
            self.delegate?.onError(error: error)
          }
        }
    }
    else {
      self.delegate?.onError(error: WsError.failedToConvertActionToJSON)
    }
  }
  func listen() {
    // sistens for new messages
    webSocketTask?
      .receive { result in
        switch result {
          case .failure(let error):
            self.delegate?.onError(error: error)
          case .success(let message):
            switch message {
              case .string(let text):
                self.delegate?.onMessage(msg: text)
              // We do not support binary data messages
              case .data(_):
                self.delegate?.onError(error: WsError.notSupported)
              @unknown default:
                fatalError()
            }
        }
        self.listen()
      }
  }
}
