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

    func forEachCat(_ body: (Cat) throws -> Void) rethrows {
        try cats.values.forEach(body)
    }

    func hotJoin(cat: Cat) {
        cats[cat.user] = cat
    }

    func calculateScores() -> (scores: [Cat: Int], miceMissed: Int, miceLeft: Int) {
        var scores = cats.values.reduce(into: [Cat: Int]()) { res, el in
            res[el] = 0
        }

        var miceMissed = 0
        // should be 0 afterwards
        var miceLeft = 0

        for mouse in mice {
            switch mouse.state {
            case .catchable: miceLeft += 1
            case .reachedGoal: miceMissed += 1
            case let .catched(by: cat):
                scores[cat]! += 1
            }
        }

        return (scores, miceMissed, miceLeft)
    }
}
