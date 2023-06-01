//
//  LobbyView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct LobbyView: View {
  @Binding var username: String
  @Binding var currentView: MainViews  // current view being passed to view

  func connect() {
    if username.isEmpty {
      return
    }
    GameSession.join(userName: username)
    currentView = .loadingScreen
  }

  var body: some View {
    VStack {
      Text("Join the server")
        .font(.largeTitle)
        .bold()

      HStack {
        TextField(
          "Username",
          text: $username
        )
        .textFieldStyle(.roundedBorder)
        .onSubmit {
          connect()
        }

        Button {
          username = RandomTextSelector(fileName: "usernames")
            .getRandomListElement()
        } label: {
          Image(systemName: "shuffle")
        }
        .help("Select a random usernaem")
      }

      Button {
        connect()
      } label: {
        Text("Join")
          .frame(maxWidth: .infinity)
      }
      .disabled(username.isEmpty)
      .buttonStyle(.borderedProminent)
      .tint(username.isEmpty ? .white : .accentColor)
      .help(username.isEmpty ? "You must enter a username" : "")

    }
    .controlSize(.large)
    .frame(maxWidth: 220)
    .navigationTitle("Join")

  }
}
