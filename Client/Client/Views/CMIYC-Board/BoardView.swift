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
    KeyboardManager.disableAlertToneAndKeyboardInput()
  }

  var body: some View {
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
      if let scoreBoard = data.scoreBoard {
        let _ = print(scoreBoard)
        let miceCounterText = Text("Mice left: \(scoreBoard.miceLeft)")
        context.draw(
          miceCounterText,
          at: CGPoint(x: 720, y: 0),
          anchor: .topLeading
        )

        let scores = scoreBoard.scores.map { item in (item.cat, item.score) }
        for (userCounter, (usr, score)) in scores.enumerated() {
          let userScore = Text("\(usr.name) \(score)")
          context.draw(
            userScore,
            at: CGPoint(x: 4, y: (userCounter * 18)),
            anchor: .topLeading
          )
        }
      }

      let _ = print("Current direction \(data.playerDirection.rawValue)")
    }

    .frame(width: 800, height: 800)
    .border(Color.blue)
    .onChange(of: data.gameState) { newGameState in
      if newGameState == nil {
        KeyboardManager.endableAlertToneAndKeyboardInput()
        currentView = .end
      }
    }
  }
}
