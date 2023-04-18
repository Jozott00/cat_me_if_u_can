//
//  LobbyView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct LobbyView: View {
  @Binding var currentView: Int  // current view being passed to view
  var body: some View {
    // Text("Lobby")
    // contains username input
    // contains start game button

    Button("Play") {
      currentView = 2
    }
  }
}

struct LobbyView_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper(1) { LobbyView(currentView: $0) }
  }
}
