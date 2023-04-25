//
//  WebsocketInnerView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

// TODO: Remove when done with testing
struct WebsocketInnerView: View {
  @EnvironmentObject var gameData: GameData

  var body: some View {
    let ws = WebsocketClient(gameData: gameData)

    Button("Start Websocket") {
      ws.start(userName: "tim2")
    }
    Button("Stop Websocket") {
      //        FIXME: method does not disconnect
      ws.stop()
    }
    if let gameState = gameData.gameState {
      Text("Game state: \(gameState.cats.count)")
    }
    if let gameLayout = gameData.gameLayout {
      Text("Game layout: \(gameLayout.exits.count)")
    }

  }
}

struct WebsocketInnerView_Previews: PreviewProvider {
  static var previews: some View {
    WebsocketInnerView()
  }
}
