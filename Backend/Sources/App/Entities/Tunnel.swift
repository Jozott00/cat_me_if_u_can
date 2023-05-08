//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import Shared

class Tunnel {
  let id: UUID
  let exits: [Exit]
  let isGoal: Bool

  init(id: UUID, exits: [Exit], isGoal: Bool) {
    self.id = id
    self.exits = exits
    self.isGoal = isGoal
  }
}
