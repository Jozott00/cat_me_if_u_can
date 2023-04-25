//
//  WebsocketInnerView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

// TODO: Remove when done with testing
struct WebsocketInnerView: View {
  var body: some View {
    let ws = WebsocketClient()
    Button("Start Websocket") {
      ws.start(userName: "tim2")
    }
    Button("Stop Websocket") {
      //        FIXME: method does not disconnect
      ws.stop()
    }

  }
}

struct WebsocketInnerView_Previews: PreviewProvider {
  static var previews: some View {
    WebsocketInnerView()
  }
}
