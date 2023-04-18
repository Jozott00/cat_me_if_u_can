//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import Shared

class Mouse: Character {
    let id: UUID
    var position: Position

    init(id: UUID, position: Position) {
        self.id = id
        self.position = position
    }
}
