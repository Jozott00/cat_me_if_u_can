//
//  User.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import Shared
import WebSocketKit

/// User represents the connection to the client device
class User: Hashable {
    let id: UUID
    let websocket: WebSocket
    var joined = false // checks if user is part of actual game
    var name: String?

    init(id: UUID, ws: WebSocket) {
        websocket = ws
        self.id = id
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
