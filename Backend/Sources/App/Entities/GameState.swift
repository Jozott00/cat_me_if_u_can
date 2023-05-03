//
//  GameState.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

actor GameState {
    let tunnels: [Tunnel]
    let mice: [Mouse]
    var cats: [User: Cat]

    let startTime: Date = .init()
    private(set) var endTime: Date!

    init(tunnels: [Tunnel], mice: [Mouse], cats: [User: Cat]) {
        self.tunnels = tunnels
        self.mice = mice
        self.cats = cats
    }

    func endGame() {
        endTime = Date()
    }

    func add(cat: Cat) {
        cats[cat.user] = cat
    }

    func removeCat(by user: User) {
        cats.removeValue(forKey: user)
    }

    func forEachCat(body: (Cat) -> Void) {
        for cat in cats.values {
            body(cat)
        }
    }
}
