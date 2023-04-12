//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

class Board {
    let subways: [Subway]
    let characters: [Character]

    init(subways: [Subway], characters: [Character]) {
        self.subways = subways
        self.characters = characters
    }
}
