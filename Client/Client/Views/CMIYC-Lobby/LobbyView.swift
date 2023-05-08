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
    VStack {
      CMIYC_TextInput(username: $username)
      Button("Play") {
        GameSession.start(userName: username)
        currentView = .board
      }
    }
  }
}
