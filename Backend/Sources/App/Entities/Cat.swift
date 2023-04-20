//
//  Cat.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import Shared

class Cat: Character {
    let id: UUID
    var position: Position
    var movement: ProtoDirection = .stay
    let user: User

    init(id: UUID, position: Position, user: User) {
        self.id = id
        self.position = position
        self.user = user
    }
}
