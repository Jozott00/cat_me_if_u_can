//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import WebSocketKit

class User {
    let websocket: WebSocket
    let name: String

    init(ws: WebSocket, name: String) {
        self.websocket = ws
        self.name = name
    }
}
