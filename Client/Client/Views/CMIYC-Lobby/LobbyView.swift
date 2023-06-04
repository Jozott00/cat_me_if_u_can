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

  }

  var body: some View {
    VStack {
      Text("Join the server")
        .font(.largeTitle)
        .bold()
        .padding(.bottom, 12)

      HStack {
        TextField(
          "Username",
          text: $username
        )
        .textFieldStyle(.roundedBorder)

        Button {
          username = RandomTextSelector(fileName: "usernames")
            .getRandomListElement()
        } label: {
          Image(systemName: "shuffle")
        }
        .help("Select a random username")
      }

      Button {
        if username.isEmpty {
          return
        }
        GameSession.join(userName: username)
        currentView = .loadingScreen
      } label: {
        Text("Join")
          .frame(maxWidth: .infinity)
      }
      .disabled(username.isEmpty)
      .keyboardShortcut(.defaultAction)
      .buttonStyle(.borderedProminent)
      .tint(username.isEmpty ? .white : .accentColor)
      .help(username.isEmpty ? "You must enter a username" : "")

    }
    .controlSize(.large)
    .frame(maxWidth: 220)
  }
}
