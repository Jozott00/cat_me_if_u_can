//
//  BoardView.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Shared
import SwiftUI

struct BoardView: View {
    @Binding var currentView: Int  // current view being passed to view
    @Binding var gameLayout: ProtoGameLayout
    var body: some View {
        Text("Playing Board")
        Canvas { context, size in
            for exit in gameLayout.exits {
                // let y = Text("(\(exit.position.x), \(exit.position.x)")
                let y = Text("🚇").font(.system(size: 33))
                context.draw(
                    y,
                    at: CGPoint(x: exit.position.x, y: exit.position.y)
                )
            }
        }
        .frame(width: 800, height: 800)
        .border(Color.blue)
        // uses tunnel exits, mice and cats
        // contains scoreboard

        /*ForEach(gameLayout.exits, id: \.exitID) { exit in
         let y = Text("(\(exit.position.x ?? 0), \(exit.position.x ?? 0)")
         context.draw(
             y,
             at: CGPoint(x: size.width / 2, y: 10)
         )
     }*/

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

/*struct BoardView_Previews: PreviewProvider {
 static var previews: some View {
 StatefulPreviewWrapper(2) { BoardView(currentView: $0) }
 }
 }
 */
