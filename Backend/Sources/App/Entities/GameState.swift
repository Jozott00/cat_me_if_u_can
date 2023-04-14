//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

actor GameState {
    let tunnels: [Tunnel]
    let characters: [Character]

    init(tunnels: [Tunnel], characters: [Character]) {
        self.tunnels = tunnels
        self.characters = characters
    }
}
