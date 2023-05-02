//
//  File.swift
//
//
//  Created by Johannes Zottele on 02.05.23.
//

import Foundation
import Shared
import Vapor

private let log = Logger(label: "LobbyController")

class LobbyController: NetworkDelegate {
    private var joinedUsers = SafeArray<User>()
    private let networkManager: NetworkManager
    private let game: GameController

    private var gameRunning = false

    init(game: GameController, networkManager: NetworkManager) {
        self.game = game
        self.networkManager = networkManager
        networkManager.delegates.append(self)
    }

    /// checks if a new game should be started
    private func checkForNewStartGame() {
        guard !gameRunning else { return }
        guard joinedUsers.count >= 2 else { return }

        Task {
            gameRunning = true
            await game.startGame(users: joinedUsers.plain)
            gameRunning = false
            log.info("Game stopped!")
        }
    }

    // TODO: make threadsafe
    private func onJoin(user: User, name: String) async {
        guard !joinedUsers.contains(where: { u in u == user }) else {
            let err = ProtoError(code: .alreadyJoined, message: "You already joined the gamelobby!")
            return await networkManager.send(msg: err, to: user)
        }

        joinedUsers.append(user)

        // send client join ack
        let ack = ProtoUpdate(data: .joinAck(id: user.id.uuidString))
        await networkManager.send(msg: ack, to: user)

        checkForNewStartGame()
    }

    /// checks if the game should be stopped
    ///
    /// e.g. because of too few players
    private func checkForStopGame() {
        guard gameRunning else { return }
        guard joinedUsers.count <= 1 else { return }
        game.stopGame()
    }

    private func onLeave(user: User) {
        joinedUsers.removeAll { u in u == user }
        checkForStopGame()
    }

    func on(action: ProtoAction, from user: User) async {
        switch action.data {
        case let .join(username: username):
            await onJoin(user: user, name: username)
        case .leave:
            onLeave(user: user)
        default:
            // do nothing
            break
        }
    }
}
