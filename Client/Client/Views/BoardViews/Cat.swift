//
//  Cat.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Shared
import SwiftUI

struct Cat {
    static func draw(
        context: GraphicsContext,
        cat: ProtoCat
    ) {
        let username = Text("ABC").font(.system(size: 10))
        let catEmoji = Text("😺").font(.system(size: 33))
        context.draw(
            catEmoji,
            at: CGPoint(x: cat.position.x, y: cat.position.y)
        )
        context.draw(
            username,
            at: CGPoint(x: cat.position.x, y: cat.position.y - 25)
        )
    }
}
