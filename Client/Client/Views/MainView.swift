//
//  MainView.swift
//  Client
//
//  Created by Tim Dirr on 18.04.23.
//

import Shared
import SwiftUI

struct MainView: View {
    @State private var currentView: Int = 1

    @State private var username: String = RandomTextSelector(fileName: "usernames")
        .getRandomListElement()

    var body: some View {
        // 4 main view with global navigation
        if currentView == 1 {
            LobbyView(username: $username, currentView: $currentView)
        }
        else if currentView == 2 {
            LoadingScreenView(
                currentView: $currentView
            )
        }
        else if currentView == 3 {
            BoardView(currentView: $currentView)
                .environmentObject(GameSession.data)
        }
        else if currentView == 4 {
            EndScreenView(currentView: $currentView)
        }
        else {
            // maybe hier noch gescheite exception einbauen, kein plan wie das mit throws functioniert in ner view
            let _ = print(UIError.NavigationError)
        }
    }
}
