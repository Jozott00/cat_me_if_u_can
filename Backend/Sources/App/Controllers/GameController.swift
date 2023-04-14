//
//  File.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation
import Shared
import Vapor

final class GameController: NetworkDelegate {
    private static let log = Logger(label: "GameController")

    init() {}

    func on(action: ProtoAction, from user: User, receivedBy manager: NetworkManager) {
        GameController.log.info("Recognize action \(action.type.rawValue) by \(user.id.uuidString)")
        if action.type == .move {
            // test individual client sending
            Task {
                await user.send(update: ProtoUpdate(type: .ack))
            }
        } else {
            // Test message broadcasting
            Task {
                await manager.broadcast(body: ProtoUpdate(type: .ack))
            }
        }
    }
}
