//
//  BoardView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Shared
import SwiftUI

struct BoardView: View {
    @Binding var currentView: MainViews
    @EnvironmentObject var data: GameData

    init(
        currentView: Binding<MainViews>
    ) {
        self._currentView = currentView
        // omits alert sound when pressing down keys
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in return nil }
    }

    var body: some View {
        Text("Playing Board")
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
            }
            if let scoreBoard = data.scoreBoard {
                let _ = print(scoreBoard)
                var miceCounterText = Text("Mice left: \(scoreBoard.miceLeft)")
                context.draw(
                    miceCounterText,
                    at: CGPoint(x: 20, y: 20)
                )
                var userCounter = 0
                var sortedScores = scoreBoard.scores.sorted(by: { $0.1 < $1.1 })
                for (usr, score) in sortedScores {
                    var userScore = Text("\(usr.name) \(score)")
                    context.draw(
                        miceCounterText,
                        at: CGPoint(x: 40 + (userCounter * 20), y: 20)
                    )
                    userCounter += 1
                }

            }

            let _ = print("Current direction \(data.playerDirection.rawValue)")
        }

        .frame(width: 800, height: 800)
        .border(Color.blue)

        Button(
            "Return to Lobby",
            action: {
                currentView = .lobby
            }
        )

        Button(
            "Go to endscreen",
            action: {
                currentView = .end
            }
        )
    }
}
