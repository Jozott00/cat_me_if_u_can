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

      let scores = (data.scoreBoard?.scores ?? [ProtoScore(cat: ProtoCat(playerID: "a", position: Position(x: 0, y: 0), name: "Flotschi"), score: 23)])
        .sorted {  a, b in a.score > b.score  }
      
      List {
        ForEach(Array(scores.enumerated()), id: \.element.cat.playerID) { index, score in
          HStack {
            Text("\(index == 0 ? "👑" : "\(index+1))") \(score.cat.name)")
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
    .controlSize(.large)
    .frame(maxWidth: 240)
  }
}
