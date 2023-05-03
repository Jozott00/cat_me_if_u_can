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
    let user: User

    var position: Position
    var movement: ProtoDirection = .stay

    init(id: UUID, position: Position, user: User) {
        self.id = id
        self.position = position
        self.user = user
    }
}
