//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import Shared
import WebSocketKit

/// User represents the connection to the client device
class User {
    let id: UUID
    let websocket: WebSocket
    var joined = false // checks if user already joined a game

    init(id: UUID, ws: WebSocket, networkManager: NetworkManager) {
        self.websocket = ws
        self.id = id
    }
}
