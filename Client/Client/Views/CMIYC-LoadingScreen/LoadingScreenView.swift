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
      Text("\(data.activeUsers?.count ?? 0) Player")
        .font(.largeTitle)
        .bold()

      List {
        if let users = data.activeUsers {
          ForEach(Array(users.enumerated()), id: \.offset) { index, user in
            HStack {
              Text("\(user.name)")
              Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(index % 2 == 0 ? .gray.opacity(0.1) : .white.opacity(0))
            .clipShape(RoundedRectangle(cornerRadius: 6))
          }
        }
      }
      .frame(maxHeight: 140)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .inset(by: 1)
          .stroke(.separator, lineWidth: 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 10))

      Button(
        action: {
          GameSession.gameStart()
        },
        label: {
          Text("Start the game")
            .frame(maxWidth: .infinity)
        }
      )
      .keyboardShortcut(.defaultAction)
      .buttonStyle(.borderedProminent)
      .tint(.accentColor)
    }
    .onChange(of: data.gameState) { gameState in
      if gameState != nil {
        currentView = .board
      }
    }
    .controlSize(.large)
    .frame(maxWidth: 220)
  }
}
