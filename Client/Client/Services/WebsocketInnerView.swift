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
      let connection = WebSocketTaskConnection(url: URL(string: "ws://catme.dobodox.com/connect")!)
      connection.delegate = WebSocketAppDelegate()
      print("Pressed Button")
      connection.connect()
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
      connection.send(text: payload)

    }
  }
}

struct WebsocketInnerView_Previews: PreviewProvider {
  static var previews: some View {
    WebsocketInnerView()
  }
}
