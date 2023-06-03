//
//  BoardView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Logging
import Shared
import SwiftUI

struct BoardView: View {
  @Binding var currentView: MainViews
  @EnvironmentObject var data: GameData
  private let log = Logger(label: "BoardView")
  var ToneSupressMonitor: Any?

  init(
    currentView: Binding<MainViews>
  ) {
    self._currentView = currentView
    // omits alert sound when pressing down keys
  }

  var body: some View {
    VStack(spacing: 0) {
      let miceLeft = data.scoreBoard?.miceLeft ?? 0
      Text("\(miceLeft) \(miceLeft == 1 ? "Mouse" : "Mice") left")
        .bold()
        .font(.largeTitle)
        .padding(.top, 8)

      HStack(alignment: .center, spacing: 0) {
        VStack(spacing: 0) {
          let scores = (data.scoreBoard?.scores ?? [])
            .sorted { a, b in a.score > b.score }
          let highScore = scores.map { s in s.score }.max()

          Text("Scores")
            .font(.title2)
            .bold()
            .padding(.top, 10)

          List {
            ForEach(Array(scores.enumerated()), id: \.element.cat.playerID) { index, score in
              HStack {
                Text(score.cat.name + (score.score > 0 && score.score == highScore ? " 👑" : ""))
                Spacer()
                Text(String(score.score))
              }
              .padding(.horizontal, 10)
              .padding(.vertical, 6)
              .background(index % 2 == 0 ? .gray.opacity(0.1) : .white.opacity(0))
              .clipShape(RoundedRectangle(cornerRadius: 6))
            }
          }
          .animation(.default, value: scores)
          .frame(minWidth: 220, maxWidth: 350, maxHeight: 300)
        }
        .background(.background)
        .clipShape(
          RoundedCornersShape(radius: 10, corners: .right)
        )
        .clipped()
        .shadow(radius: 4)

        Spacer()

        Canvas { context, _ in
          if let gameLayout = data.gameLayout {
            for exit in gameLayout.exits {
              Exit.draw(context: context, exit: exit)
            }
          }

          if let gameState = data.gameState {
            for mouse in gameState.mice {
              Mouse.draw(context: context, mouse: mouse)
            }
            for cat in gameState.cats {
              Cat.draw(context: context, cat: cat)
            }
          } else {
            log.info("Game Ended")
          }

          let _ = print("Current direction \(data.playerDirection.rawValue)")
        }
        .frame(width: 800, height: 800)
        .onChange(of: data.gameState) { newGameState in
          if newGameState == nil {
            KeyboardManager.endableAlertToneAndKeyboardInput()
            currentView = .end
          }
        }
      }
    }
    .frame(minHeight: 840)
  }
}
