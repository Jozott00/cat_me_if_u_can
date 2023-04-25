//
//  WebSocketTaskConnection.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//  Inspired by https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/WebSocketConnection.swift

import Foundation

class WebSocketTaskConnection: NSObject, WebSocketConnection, URLSessionWebSocketDelegate {

  var delegate: WebSocketConnectionDelegate?
  var webSocketTask: URLSessionWebSocketTask!
  var urlSession: URLSession!
  let delegateQueue = OperationQueue()
  enum WsError: Error {
    // Throw when WS experiences a state that is not supported
    case notSupported
  }

  init(
    url: URL
  ) {
    super.init()
    urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
    webSocketTask = urlSession.webSocketTask(with: url)
  }

  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didOpenWithProtocol protocol: String?
  ) {
    // called after webSocketTask.resume()
    self.delegate?.onConnected(connection: self)
  }

  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
    reason: Data?
  ) {
    // called after webSocketTask.cancel()
    self.delegate?.onDisconnected(connection: self, error: nil)
  }

  func connect() {
    webSocketTask.resume()
    self.listen()
  }
  func disconnect() {
    webSocketTask.cancel(with: .goingAway, reason: nil)
  }
  func send(msg: String) {
    // sends a plain texst message
    webSocketTask.send(URLSessionWebSocketTask.Message.string(msg)) { error in
      if let error = error {
        self.delegate?.onError(error: error)
      }
    }
  }
  func listen() {
    // sistens for new messages
    webSocketTask.receive { result in
      switch result {
        case .failure(let error):
          self.delegate?.onError(error: error)
        case .success(let message):
          switch message {
            case .string(let text):
              self.delegate?.onMessage(connection: self, msg: text)
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
