//
//  EndScreenView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Shared
import SwiftUI

struct EndScreenView: View {
    @Binding var currentView: MainViews
    @EnvironmentObject var data: GameData
    var body: some View {
        Text("Final Score")
        if let scoreBoard = data.scoreBoard {
            let sortedScores = scoreBoard.scores.sorted(by: { $0.1 < $1.1 })
            ForEach(sortedScores, id: \.key) { (usr, score) in
                Text("\(usr.name) \(score)")
            }
        }

        Button(
            "Leave lobby",
            action: {
                currentView = .lobby
            }
        )
        Button(
            "Play again",
            action: {
                currentView = .loadingScreen
            }
        )
    }
}
