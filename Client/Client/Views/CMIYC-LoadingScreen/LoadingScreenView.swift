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
      Text("Users in Lobby")
        .font(.largeTitle)
        .bold()

      List {
        if let users = data.activeUsers {
          ForEach(Array(users.enumerated()), id: \.offset) { index, user in
            Text("\(index + 1). \(user.name)")
              .listRowSeparator(.visible)
          }
        }
      }
      .cornerRadius(10.0)
      .frame(maxHeight: 140)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .inset(by: 1)
          .stroke(.separator, lineWidth: 1)
      )

      Button(
        action: {
          GameSession.gameStart()
        },
        label: {
          Text("Start the game")
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.borderedProminent)
      .tint(.accentColor)
    }
    .onChange(of: data.gameState) { gameState in
      if gameState != nil {
        currentView = .board
      }
    }
    .controlSize(.large)
    .navigationTitle("Lobby")
    .frame(maxWidth: 220)
  }
}
