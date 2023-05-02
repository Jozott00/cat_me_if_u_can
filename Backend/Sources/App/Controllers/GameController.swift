//
//  GameController.swift
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
    private let tickIntervalMS: TimeInterval
    private var isRunning = false
    private var gameState = GameState(tunnels: [], mice: [], cats: [:])

    init(networkManager: NetworkManager, tickIntervalMS: TimeInterval = 1000) {
        self.tickIntervalMS = tickIntervalMS
        self.networkManager = networkManager
        networkManager.delegates.append(self)
    }

    func startGame(users: [User]) async {
        guard !isRunning else { return }
        log.info("Start Game")
        isRunning = true
        let cats = generateCats(from: users)
        log.info("Generate tunnels")
        gameState = GameState(tunnels: generateTunnels(), mice: [], cats: cats)

        log.info("Join all users")
        // set all users to joined, so they get game updates
        users.forEach { u in u.joined = true }

        log.info("Broadcast layout")
        // broadcast gamelayout
        await broadcastGameLayout()

        log.info("Run eventloop")
        while isRunning {
            tick()

            let nanoseconds = Int64(tickIntervalMS * TimeInterval(1_000_000))
            do {
                try await Task.sleep(nanoseconds: UInt64(nanoseconds))
            } catch {
                log.error("Game loop interrupted: \(error.localizedDescription)")
            }
        }
    }

    func stopGame() {
        log.info("Stop game...")
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

    private func calculateGameState() async {
        await gameState.forEachCat(body: calculateCatPosition)

        // TODO: calculate mice

        // TODO: check collisions (mice and cats)
    }

    // TODO: consider to move logic somewhere else
    private func calculateCatPosition(cat: Cat) {
        let movementVector = cat.movement.vector * Constants.MOVEMENT_PER_TICK
        let boardBoundaries = Vector2(Constants.FIELD_LENGTH, Constants.FIELD_LENGTH)
        cat.position.translate(vec: movementVector, within: boardBoundaries)
    }

    private func broadcastGameState() async {
        let cats = (await gameState.cats).map { _, cat in ProtoCat(playerID: cat.id.uuidString, position: cat.position) }
        let protoGameState = ProtoGameState(mice: [], cats: cats)
        let update = ProtoUpdate(data: .gameState(state: protoGameState))
        await networkManager.broadcast(body: update, onlyIf: { user in user.joined })
    }

    private func broadcastGameLayout() async {
        let exits = gameState.tunnels.map { t in
            t.exits.map { e in ProtoExit(exitID: e.id.uuidString, position: e.position) }
        }.reduce([], +)
        let update = ProtoUpdate(data: .gameLayout(layout: ProtoGameLayout(exits: exits)))
        await networkManager.broadcast(body: update, onlyIf: { user in user.joined })
    }

    func on(action: ProtoAction, from user: User) async {
        log.info("Recognize action \(action.data) by \(user.id.uuidString)")

        switch action.data {
        case let .move(direction: direction):
            await handleMove(direction: direction, from: user)
        case .leave:
            await handleLeave(from: user)
        default:
            break
        }
    }

    func handleMove(direction: ProtoDirection, from user: User) async {
        let cat = await gameState.cats[user]

        guard user.joined, let cat = cat else {
            let err = ProtoError(code: .userNotYetJoined, message: "The user hasn't joined yet, so movement is not possible")
            return await networkManager.send(msg: err, to: user)
        }

        // set new movement direction
        cat.movement = direction
    }

    func handleLeave(from user: User) async {
        await gameState.removeCat(by: user)
    }

    private func generateCats(from users: [User]) -> [User: Cat] {
        return users.reduce(into: [User: Cat]()) { res, u in
            let catPos = Position.random(in: 0 ... Double(Constants.FIELD_LENGTH))
            res[u] = Cat(id: u.id, position: catPos, user: u)
        }
    }
}
