//
//  LoadingScreenView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct LoadingScreenView: View {
  @Binding var currentView: Int  // current view being passed to view
  var body: some View {
    Text("Loading Screen")

    // contains Loading Text and Loading Indicotor
    // contains insta start game button for testing
      Button("Skip button to insta start game for testing", action: {
      currentView = 3
      })
      
    // maybe add countdown before start of the game
  }
}

struct LoadingScreenView_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper(3) { LoadingScreenView(currentView: $0) }
  }
}
