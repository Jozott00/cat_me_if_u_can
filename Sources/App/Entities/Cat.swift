//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

class Cat: Character {
    var position: Position
    let user: User

    init(position: Position, user: User) {
        self.position = position
        self.user = user
    }
}
