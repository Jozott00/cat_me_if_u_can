import Foundation

class WebSocket: NSObject, URLSessionWebSocketDelegate {

  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didOpenWithProtocol protocol: String?
  ) {
    print("Web Socket did connect")
    receive(webSocketTask: webSocketTask)
  }

  func urlSession(
    _ session: URLSession,
    webSocketTask: URLSessionWebSocketTask,
    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
    reason: Data?
  ) {
    print("Web Socket did disconnect")
  }

  func ping(webSocketTask: URLSessionWebSocketTask) {
    webSocketTask.sendPing { error in
      if let error = error {
        print("Error when sending PING \(error)")
      }
      else {
        print("Web Socket connection is alive")
        DispatchQueue.global()
          .asyncAfter(deadline: .now() + 5) {
            self.ping(webSocketTask: webSocketTask)
          }
      }
    }
  }

  func close(webSocketTask: URLSessionWebSocketTask) {
    let reason = "Closing connection".data(using: .utf8)
    webSocketTask.cancel(with: .goingAway, reason: reason)
  }

  func send(webSocketTask: URLSessionWebSocketTask) {
    //  DispatchQueue.global()
    //    .asyncAfter(deadline: .now() + 1) {
    //      send()
    let payload = """
      {
          "timestamp": 168488694.712589,
          "body": {
              "action": {
                  "action": {
                      "data": {
                          "join":{
                              "username":"Tim2"
                          }
                      }
                  }
              }
          }
      }
      """
    webSocketTask.send(.string(payload)) { error in
      if let error = error {
        print("Error when sending a message \(error)")
      }
    }
    //    }
  }

  func receive(webSocketTask: URLSessionWebSocketTask) {
    webSocketTask.receive { result in
      switch result {
        case .success(let message):
          switch message {
            case .data(let data):
              print("Data received \(data)")
            case .string(let text):
              print("Text received \(text)")
          }
        case .failure(let error):
          print("Error when receiving \(error)")
      }
      self.receive(webSocketTask: webSocketTask)
    }
  }

}
