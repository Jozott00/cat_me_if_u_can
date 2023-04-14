//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation
import Shared
import WebSocketKit

class User {
    let id: UUID
    let websocket: WebSocket
    private let networkManager: NetworkManager

    init(id: UUID, ws: WebSocket, networkManager: NetworkManager) {
        self.websocket = ws
        self.id = id
        self.networkManager = networkManager
    }

    func send(update: ProtoUpdate) async {
        await networkManager.sendToClient(body: update, to: self)
    }

    func send(error: ProtoError) async {
        await networkManager.sendToClient(body: error, to: self)
    }
}
