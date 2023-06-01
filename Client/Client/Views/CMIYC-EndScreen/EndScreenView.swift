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
      let sortedScores = scoreBoard.scores.sorted { a, b in a.score > b.score }
      ForEach(Array(sortedScores.enumerated()), id: \.element.cat.playerID) { index, scoreItem in
        let cat = scoreItem.cat
        let score = scoreItem.score
        // FIXME: A table would fit perfectly here
        Text("\(index == 0 ? "👑" : "") \(cat.name) \(score)")
      }
    }

    Button(
      "Play again",
      action: {
        currentView = .loadingScreen
      }
    )
    .buttonStyle(.borderedProminent)
    .tint(.accentColor)
    
    Button(
      "Leave lobby",
      action: {
        GameSession.stop()
        currentView = .lobby
      }
    )
  }
}
