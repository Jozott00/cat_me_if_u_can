//
//  File.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation
import Shared
import Vapor

private let log = Logger(label: "GameController")

final class GameController: NetworkDelegate {
    private let networkManager: NetworkManager
    private let tickInterval: TimeInterval
    private var gameTimer: Timer?
    private var isRunning = false
    private var gameState = GameState(tunnels: [], mice: [], cats: [])

    init(networkManager: NetworkManager, tickInterval: TimeInterval = 1) {
        self.tickInterval = tickInterval
        self.networkManager = networkManager
        networkManager.delegate = self
    }

    func startGame() async {
        guard !isRunning else { return }
        log.info("Start Game")
        isRunning = true
        gameState = GameState(tunnels: generateTunnels(), mice: [], cats: [])

        while isRunning {
            tick()

            let nanoseconds = Int64(tickInterval * TimeInterval(1_000_000_000))
            do {
                try await Task.sleep(nanoseconds: UInt64(nanoseconds))
            } catch {
                log.error("Game loop interrupted: \(error.localizedDescription)")
            }
        }
    }

    func stopGame() {
        isRunning = false
    }

    private func tick() {
        Task {
            // start calculation of next tick
            await calculateGameState()
            // start broadcasting of current state
            await broadcastGameState()
        }
    }

    private func calculateGameState() async {}

    private func broadcastGameState() async {
        // currently just broadcast demo data
        let exits = gameState.tunnels.map { t in
            t.entries.map { e in ProtoExit(exitID: e.id.uuidString, position: e.position) }
        }.reduce([], +)

        let protoGameState = ProtoGameState(
            mice: [],
            cats: [],
            exits: exits
        )
        let update = ProtoUpdate(data: .gameState(state: protoGameState))
        await networkManager.broadcast(body: update, onlyIf: { user in user.joined })
    }

    func on(action: ProtoAction, from user: User) async {
        log.info("Recognize action \(action.data) by \(user.id.uuidString)")

        switch action.data {
        case let .move(direction: direction):
            await handleMove(direction: direction, from: user)
        case let .join(username: username):
            await handleJoin(from: user, name: username)
        case .leave:
            await handleLeave(from: user)
        }
    }

    func handleMove(direction _: ProtoDirection, from _: User) async {
        // TODO: Handle movement
    }

    func handleLeave(from _: User) async {
        // TODO: Handle leave
    }

    func handleJoin(from user: User, name _: String) async {
        guard !user.joined else {
            let err = ProtoError(code: .alreadyJoined, message: "You already joined the game!")
            return await networkManager.sendToClient(body: err, to: user)
        }

        user.joined = true
        // TODO: Handle Join
    }
}
