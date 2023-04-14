//
//  NetworkManager.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation
import Shared
import Vapor

/// `NetworkManager` is responsible for managing WebSocket connections and communicating with clients.
/// It provides an interface to send messages to the connected clients and handles incoming messages.
final class NetworkManager {
    /// `NetworkDelegate` should be implemented by any class that wants to listen
    /// for incoming messages and respond to client disconnections.
    var delegate: NetworkDelegate?
    
    /// Logger instance for `NetworkManager`.
    private let log = Logger(label: "NetworkManager")
    
    /// A dictionary to store connected clients, where the key is a UUID and the value is a `User` object.
    private var connectedClients: [UUID: User] = [:]
    /// A DispatchQueue to manage concurrent access to the `connectedClients` dictionary.
    private let connectionsQueue = DispatchQueue(label: "com.cat-me.networkManager.connectionsQueue")
    
    /// Configures WebSocket routes for the application.
    /// It sets up a WebSocket route to handle client connections, disconnections, and incoming messages.
    ///
    /// - Parameter routes: A `RoutesBuilder` instance to add routes to.
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
                Task {
                    await self.clientDisconnected(user: user)
                }
            }
            
            ws.onText { _, text in
                Task {
                    await self.handleIncomingMessage(user: user, message: text)
                }
            }
        }
    }
    
    /// Broadcasts a message to all connected clients.
    /// It serializes the provided message and sends it to all connected clients concurrently.
    ///
    /// - Parameter body: A `ProtoBody` instance to be sent to all clients.
    func broadcast(body: ProtoBody) async {
        let clients = connectionsQueue.sync {
            self.connectedClients
        }
            
        await withTaskGroup(of: Void.self) { group in
            for user in clients.values {
                group.addTask {
                    await self.sendToClient(body: body, to: user)
                }
            }
            await group.waitForAll()
        }
    }
    
    /// Sends a message to a specific client.
    ///
    /// It serializes the provided message and sends it to the target client.
    ///
    /// - Parameters:
    ///   - body: A `ProtoBody` instance to be sent to the specified client.
    ///   - user: The target `User` object representing the client to receive the message.
    func sendToClient(body: ProtoBody, to user: User) async {
        do {
            let msg = body.createMsg()
            let json = try JSONEncoder().encode(msg)
            try await user.websocket.send(json.str(.utf8)!)
        } catch {
            log.error("Error while sending message to client: \(error.localizedDescription)")
        }
    }
    
    /// Called when a client disconnects.
    ///
    /// It creates a `ProtoAction` with the `leave` type and informs the delegate
    /// about the disconnection event.
    ///
    /// - Parameter user: The `User` object representing the disconnected client.
    private func clientDisconnected(user: User) async {
        let action = ProtoAction(data: .leave)
        await delegate?.on(action: action, from: user)
    }
    
    /// Handles an incoming message from a client.
    ///
    /// It decodes the message, checks its type, and forwards the message to the delegate
    /// if it's an action. If the message type is not an action, it sends an error message back to the client.
    ///
    /// - Parameters:
    ///   - user: The `User` object representing the client that sent the message.
    ///   - message: The received message as a string.
    private func handleIncomingMessage(user: User, message: String) async {
        do {
            let data = message.data(using: .utf8)!
            let decoder = JSONDecoder()
            let msg: ProtocolMsg = try decoder.decode(ProtocolMsg.self, from: data)
            
            if case let .action(action: action) = msg.body {
                await delegate?.on(action: action, from: user)
            } else {
                let err = ProtoError(code: .genericError, message: "Type of message was not action.")
                await sendToClient(body: err, to: user)
            }
            
        } catch {
            log.error("Error while handling incoming message: \(error.localizedDescription)")
        }
    }
}
