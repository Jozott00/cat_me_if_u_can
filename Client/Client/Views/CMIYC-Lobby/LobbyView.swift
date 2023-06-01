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

  var body: some View {
    VStack(alignment: .leading) {
      
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
        .help("Select a random usernaem")
      }
      
        
      Button {
        GameSession.join(userName: username)
        currentView = .loadingScreen
      } label: {
        Text("Join")
          .frame(maxWidth: .infinity)
      }
      .disabled(username.isEmpty)
      .buttonStyle(.borderedProminent)
      .tint(username.isEmpty ? .white : .blue)
      .help(username.isEmpty ? "You must enter a username" : "")
    }
    
    .controlSize(.large)
    .frame(maxWidth: 180)
  }
}
