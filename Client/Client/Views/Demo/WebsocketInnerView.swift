//
//  WebsocketInnerView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

struct WebsocketInnerView: View {
  @EnvironmentObject var game: GameSession
  @EnvironmentObject var data: GameData

  var body: some View {
    Button("Start Websocket") {
      game.start(userName: "tim2", data: self.data)
    }
    Button("Stop Websocket") {
      game.stop()
    }
    if let gameState = data.gameState {
      Text("Game state: \(gameState.cats.count)")
    }
    if let gameLayout = data.gameLayout {
      Text("Game layout: \(gameLayout.exits.count)")
    }

  }
}
