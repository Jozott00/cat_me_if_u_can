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
    let loadingMessagesList: RandomTextSelector = RandomTextSelector(fileName: "loading-messages")
    var body: some View {
        Text("Users in Lobby:")
        if let users = data.activeUsers {
            ForEach(users, id: \.id) { user in
                Text(user.name)
            }
        }
        // Text(loadingMessagesList.getRandomListElement())

        // contains Loading Text and Loading Indicotor
        // contains insta start game button for testing
        Button(
            "Start the game",
            action: {
                GameSession.gameStart()
                currentView = .board
            }
        )

        // maybe add countdown before start of the game
    }
}

/*struct LoadingScreenView_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper(3) { LoadingScreenView(currentView: $0) }
  }
}*/
