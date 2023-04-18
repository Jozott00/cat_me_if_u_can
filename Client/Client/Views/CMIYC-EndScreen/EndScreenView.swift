//
//  EndScreenView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct EndScreenView: View {
  @Binding var currentView: Int  // current view being passed to view
  var body: some View {
    Text("Endscreen")

    // contains leaderboard
    // contains return to lobby button
    Button(
      "Return to Lobby",
      action: {
        currentView = 1
      }
    )
  }
}

struct EndScreenView_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper(4) { EndScreenView(currentView: $0) }
  }
}
