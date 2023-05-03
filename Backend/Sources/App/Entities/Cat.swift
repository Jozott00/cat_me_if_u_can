//
//  Cat.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import Shared

class Cat: Character, Hashable {
    let id: UUID
    let user: User

    var position: Position
    var movement: ProtoDirection = .stay

    init(id: UUID, position: Position, user: User) {
        self.id = id
        self.position = position
        self.user = user
    }

    public static func == (lhs: Cat, rhs: Cat) -> Bool {
        return lhs.id == rhs.id && lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(user)
    }
}
