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
    let entries: [Entry]
    let isGoal: Bool

    init(id: UUID, entries: [Entry], isGoal: Bool) {
        self.id = id
        self.entries = entries
        self.isGoal = isGoal
    }
}
