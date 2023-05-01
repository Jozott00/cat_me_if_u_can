//
//  LobbyView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct LobbyView: View {
    @Binding var username: String
    @Binding var currentView: Int // current view being passed to view

    @EnvironmentObject var game: GameSession
    @EnvironmentObject var data: GameData

    var body: some View {
        // Text("Lobby")
        // contains username input
        VStack {
            CMIYC_TextInput(username: $username)
            // contains start game button

            Button("Play") {
                game.start(userName: username, data: data.self)
                currentView = 3
            }
        }
    }
}

/* struct LobbyView_Previews: PreviewProvider {
   static var previews: some View {
     StatefulPreviewWrapper("Tim") {
       StatefulPreviewWrapper(1) { LobbyView(username: $0, currentView: $0) }
     }
   }
 } */
