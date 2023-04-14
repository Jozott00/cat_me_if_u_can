//
//  NetworkManager.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation
import Shared
import Vapor

final class NetworkManager {
    var delegate: NetworkDelegate?
    
    private var connectedClients: [UUID: User] = [:]
    private let connectionsQueue = DispatchQueue(label: "com.cat-me.networkManager.connectionsQueue")
    
    func configureRoutes(routes: RoutesBuilder) {
        routes.webSocket("connect") { _, ws in
            let userId = UUID()
            let user = User(id: userId, ws: ws, networkManager: self)
            self.connectionsQueue.sync {
                self.connectedClients[userId] = user
            }
            
            _ = ws.onClose.always { _ in
                _ = self.connectionsQueue.sync {
                    self.connectedClients.removeValue(forKey: userId)
                }
                self.clientDisconnected(user: user)
            }
            
            ws.onText { _, text in
                self.handleIncomingMessage(user: user, message: text)
            }
        }
    }
    
    func send(update: ProtoUpdate, to user: User) async {
        do {
            let json = try JSONEncoder().encode(update)
            try await user.websocket.send(json.str(.utf8)!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func clientDisconnected(user: User) {
        let action = ProtoAction(type: .leave)
        delegate?.on(action: action, from: user, receivedBy: self)
    }
    
    private func handleIncomingMessage(user: User, message: String) {
        do {
            let data = message.data(using: .utf8)!
            let decoder = JSONDecoder()
            let msg: ProtocolMsg = try decoder.decode(ProtocolMsg.self, from: data)
            
            if let action = msg.action {
                delegate?.on(action: action, from: user, receivedBy: self)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
