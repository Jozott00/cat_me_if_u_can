//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

actor GameState {
    let tunnels: [Tunnel]
    let mice: [Mouse]
    let cats: [Cat]

    init(tunnels: [Tunnel], mice: [Mouse], cats: [Cat]) {
        self.tunnels = tunnels
        self.mice = mice
        self.cats = cats
    }
}
