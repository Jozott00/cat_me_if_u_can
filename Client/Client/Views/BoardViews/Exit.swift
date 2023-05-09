//
//  Exit.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import Shared
import SwiftUI

struct Exit {
  static func draw(
    context: GraphicsContext,
    exit: ProtoExit
  ) {
    let exitEmoji = Text("🚇").font(.system(size: 33))
    context.draw(
      exitEmoji,
      at: CGPoint(x: exit.position.x, y: exit.position.y)
    )
  }
}
