//
//  MainView.swift
//  Client
//
//  Created by Tim Dirr on 18.04.23.
//

import Shared
import SwiftUI

struct MainView: View {
    @State private var currentView: MainViews = .lobby

    @State private var username: String = RandomTextSelector(fileName: "usernames")
        .getRandomListElement()

    var body: some View {
        // 4 main view with global navigation
        switch currentView {
            case .lobby:
                LobbyView(username: $username, currentView: $currentView)

            case .loadingScreen:
                LoadingScreenView(
                    currentView: $currentView
                )
                .environmentObject(GameSession.data)
            case .board:
                BoardView(currentView: $currentView)
                    .environmentObject(GameSession.data)
            case .end:
                EndScreenView(currentView: $currentView)
                    .environmentObject(GameSession.data)
        }

    }
}

public enum MainViews: String {
    case lobby
    case loadingScreen
    case board
    case end
}
