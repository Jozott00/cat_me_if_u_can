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
    @State private var gameLayout: ProtoGameLayout = ProtoGameLayout(exits: [
        ProtoExit(exitID: "testid", position: Position(x: 10, y: 10)),
        ProtoExit(exitID: "testid", position: Position(x: 100, y: 10)),
        ProtoExit(exitID: "testid", position: Position(x: 40, y: 700)),
        ProtoExit(exitID: "testid", position: Position(x: 390, y: 210)),
    ])
    @State private var username: String = "Tim"
    var body: some View {
        // 4 main view with global navigation
        if currentView == 1 {
            LobbyView(username: $username, currentView: $currentView)
        }
        else if currentView == 2 {
            LoadingScreenView(currentView: $currentView)
        }
        else if currentView == 3 {
            BoardView(currentView: $currentView, gameLayout: $gameLayout)
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
