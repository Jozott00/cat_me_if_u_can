//
//  LoadingScreenView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct LoadingScreenView: View {
  @Binding var currentView: MainViews  // current view being passed to view
  @EnvironmentObject var data: GameData
  var body: some View {
    VStack {
      Text("Users in Lobby:")
      if let users = data.activeUsers {
        ForEach(users, id: \.id) { user in
          Text(user.name)
        }
      }

      Button(
        "Start the game",
        action: {
          GameSession.gameStart()
        }
      )
    }
    .onChange(of: data.gameState) { gameState in
      if gameState != nil {
        currentView = .board
      }
    }
  }
}
