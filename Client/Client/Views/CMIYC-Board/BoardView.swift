//
//  BoardView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Shared
import SwiftUI

struct BoardView: View {
    @Binding var currentView: Int
    @EnvironmentObject var data: GameData

    var body: some View {
        Text("Playing Board")
        Canvas { context, _ in
            if let gameLayout = data.gameLayout {
                for exit in gameLayout.exits {
                    let text = Text("🚇").font(.system(size: 33))
                    context.draw(
                        text,
                        at: CGPoint(x: exit.position.x, y: exit.position.y)
                    )
                }
            }

            if let gameState = data.gameState {
                for mouse in gameState.mice {
                    let text = Text("🐭").font(.system(size: 33))
                    context.draw(
                        text,
                        at: CGPoint(x: mouse.position.x, y: mouse.position.y)
                    )
                }
                for cat in gameState.cats {
                    let text = Text("😺").font(.system(size: 33))
                    context.draw(
                        text,
                        at: CGPoint(x: cat.position.x, y: cat.position.y)
                    )
                }
            }
        }
        .frame(width: 800, height: 800)
        .border(Color.blue)

        Button(
            "Return to Lobby",
            action: {
                currentView = 1
            }
        )

        Button(
            "Go to endscreen",
            action: {
                currentView = 4
            }
        )
    }
}
