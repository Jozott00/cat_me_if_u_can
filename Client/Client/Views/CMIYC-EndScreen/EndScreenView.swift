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
    VStack {
      Text("Scoreboard")
        .bold()
        .font(.largeTitle)
        .padding(.bottom, 3)

      let scores = (data.scoreBoard?.scores ?? [])
        .sorted { a, b in a.score > b.score }

      let missedMice = (data.scoreBoard?.miceMissed ?? 0) + (data.scoreBoard?.miceLeft ?? 0)
      let totalMice = scores.reduce(0) { t, s in t + s.score } + missedMice
      Text("Out of \(totalMice) mice \(missedMice) reached their goal.")

      let highScore = scores.map { s in s.score }.max()
      List {
        ForEach(Array(scores.enumerated()), id: \.element.cat.playerID) { index, score in
          HStack {
            Text("\(score.cat.name) \(score.score > 0 && score.score == highScore ? " 👑" : "")")
            Spacer()
            Text(String(score.score))
          }
          .padding(.horizontal, 10)
          .padding(.vertical, 6)
          .background(index % 2 == 0 ? .gray.opacity(0.1) : .white.opacity(0))
          .clipShape(RoundedRectangle(cornerRadius: 6))
        }
      }
      .frame(maxHeight: 160)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(.separator, lineWidth: 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 10))

      Button(
        action: {
          currentView = .loadingScreen
        },
        label: {
          Text("Play again")
            .frame(maxWidth: .infinity)
        }
      )
      .buttonStyle(.borderedProminent)
      .tint(.accentColor)

      Button(
        action: {
          GameSession.stop()
          currentView = .lobby
        },
        label: {
          Text("Leave lobby")
            .frame(maxWidth: .infinity)
        }
      )
    }
    .onChange(of: data.gameState) { gameState in
      if gameState != nil {
        currentView = .board
      }
    }
    .controlSize(.large)
    .frame(maxWidth: 240)
  }
}
