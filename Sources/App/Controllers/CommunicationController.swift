//
//  File.swift
//
//
//  Created by Johannes Zottele on 21.03.23.
//

import Foundation
import WebSocketKit

final class CommunicationController {
    private final var conns = ThreadSafe(element: RefArray<WebSocket>())

    func newConnection(ws: WebSocket) {
        ws.onClose.whenComplete { _ in
            print("connection gone")
            self.conns.op { elem in
                elem().remove(ws: ws)
                print("Current connections: \(elem().count)")
            }
        }
        conns.op { elem in
            elem().add(ws: ws)
            print("Current connections: \(elem().count)")
        }
        ws.onText(onMessage)
    }

    private func onMessage(ws: WebSocket, text: String) async {
        // Process Input
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(ProtocolMessage.self, from: text.data(using: .utf8)!)
            print("Got message of type: \(result)")
            let conns = conns.op { e in e() }

            try await withThrowingTaskGroup(of: Void.self) { group in
                for w in conns {
                    group.addTask {
                        try await w.send("Broadcast message of type: \(result.type)")
                    }
                }

                try await group.waitForAll()
            }

        } catch {
            print(error)
        }
    }
}
