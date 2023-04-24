//
//  WebsocketInnerView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

struct WebsocketInnerView: View {
  var body: some View {
    Button("Start Websocket") {
      let webSocketDelegate = WebSocket()
      let session = URLSession(
        configuration: .default,
        delegate: webSocketDelegate,
        delegateQueue: OperationQueue()
      )
      print("Pressed Button")
      let url = URL(string: "ws://catme.dobodox.com/connect")!
      let webSocketTask = session.webSocketTask(with: url)
      webSocketDelegate.send(webSocketTask: webSocketTask)
      webSocketTask.resume()
    }
  }
}

struct WebsocketInnerView_Previews: PreviewProvider {
  static var previews: some View {
    WebsocketInnerView()
  }
}
