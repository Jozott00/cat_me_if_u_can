//
//  WebsocketInnerView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import Shared
import SwiftUI

struct WebsocketInnerView: View {
  @EnvironmentObject var data: GameData
  var body: some View {
    VStack(alignment: .leading) {

      Button("Join Websocket") {
        GameSession.join(userName: "tim\(Int.random(in: 1...10000))")
      }
      Button("Start Websocket") {
        GameSession.gameStart()
      }
      Button("Stop Websocket") {
        GameSession.stop()
      }

      if let gameState = data.gameState {
        Text("Game state:")
        Text("Mice count: \(gameState.mice.count)")
        Text("Cats count: \(gameState.cats.count)")
        ForEach(gameState.mice, id: \.mouseID) { mouse in
          Text(
            "Mouse ID: \(mouse.mouseID), Position: (\(mouse.position.x), \(mouse.position.y)), State: \(mouse.stateDescription))"
          )
        }
        ForEach(gameState.cats, id: \.playerID) { cat in
          Text("Cat Player ID: \(cat.playerID), Position: (\(cat.position.x), \(cat.position.y))")
        }
      }
      if let gameLayout = data.gameLayout {
        Text("Game layout:")
        Text("Exits count: \(gameLayout.exits.count)")
        ForEach(gameLayout.exits, id: \.exitID) { exit in
          Text("Exit ID: \(exit.exitID), Position: (\(exit.position.x), \(exit.position.y))")
        }
      }
      Text("Current direction \(data.playerDirection.rawValue)")
    }
  }
}
