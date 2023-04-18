//
//  BoardView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct BoardView: View {
  @Binding var currentView: Int  // current view being passed to view
  var body: some View {
    Text("Playing Board")
    // uses tunnel exits, mice and cats
    // contains scoreboard
    Button(
      "Return to Lobby",
      action: {
        currentView = 1
      }
    )

    Button(
      "Go to endscreen",
      action: {
        currentView = 4
      }
    )
  }
}

struct BoardView_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper(2) { BoardView(currentView: $0) }
  }
}
