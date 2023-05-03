//
//  EndScreenView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct EndScreenView: View {
    @Binding var currentView: MainViews  // current view being passed to view
    var body: some View {
        Text("Endscreen")

        // contains leaderboard
        // contains return to lobby button
        Button(
            "Return to Lobby",
            action: {
                currentView = .lobby
            }
        )
    }
}
