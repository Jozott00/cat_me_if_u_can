//
//  Mouse.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Shared
import SwiftUI

struct Mouse {
    static func draw(
        context: GraphicsContext,
        mouse: ProtoMouse
    ) {
        let mouseEmoji = Text("🐭").font(.system(size: 33))
        context.draw(
            mouseEmoji,
            at: CGPoint(x: mouse.position.x, y: mouse.position.y)
        )
    }
}
