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

  func startGame(users: [User]) async -> GameState? {
    guard !isRunning else { return nil }
    log.info("Start Game")
    isRunning = true
    let tunnels = generateTunnels()
    let mice = spawnMice(in: tunnels)
    let cats = spawnCats(from: users)
    gameState = GameState(tunnels: tunnels, mice: mice, cats: cats)
    log.info(
      "Mice: \(mice.count), Exits: \(tunnels.reduce(0) { a, b in a + b.exits.count}), Tunnels: \(tunnels.count)"
    )

    // set all users to joined, so they get game updates
    users.forEach { u in u.inGame = true }

    // broadcast gamelayout
    await broadcastGameLayout()

    while isRunning {
      tick()

      let nanoseconds = Int64(tickIntervalMS * TimeInterval(1_000_000))
      do {
        try await Task.sleep(nanoseconds: UInt64(nanoseconds))
      } catch {
        log.error("Game loop interrupted: \(error.localizedDescription)")
      }
    }

    // set game endtime
    await gameState.endGame()

    return gameState
  }

  func stopGame() {
    log.info("Stop game...")
    isRunning = false
  }

  func hotJoin(user: User) async {
    guard isRunning else { return }
    log.info("Hot joining \(user.name!)")
    await gameState.hotJoin(cat: spawnCat(from: user))
    user.inGame = true

    let gameLayoutUpdate = createProtoGameLayout()
    await networkManager.send(msg: gameLayoutUpdate, to: user)
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
    let start = Date()
    await gameState.forEachCat(calculateCatPosition)

    let cats = (await gameState.cats.values.map { m in m })
    gameState.mice.filter { m in
      !m.isDead && !m.hasReachedGoal
    }
    .forEach { m in
      calculateMousePosition(mouse: m, tunnels: gameState.tunnels, cats: cats)
    }

    // Check collisions (mice and cats)
    await checkCollisons()
    //log.info("Elapse tick: \(Date().timeIntervalSince(start)*1000)ms")
  }

  private func calculateCatPosition(cat: Cat) {
    let movementVector = cat.movement.vector * Constants.CAT_MOVEMENT_PER_TICK
    let boardBoundaries = Vector2(Constants.FIELD_LENGTH, Constants.FIELD_LENGTH)
    cat.position.translate(vec: movementVector, within: boardBoundaries)
  }

  private func checkCollisons() async {
    // Get all mice that are on the surface and alive
    let catchableMice = gameState.mice.filter { m in
      !m.isDead && !m.isHidden
    }

    // Kill all mice that are too close to a cat
    await gameState.forEachCat { cat in
      catchableMice.filter { mouse in
        mouse.position.distance(to: cat.position)
          < (Constants.CAT_SIZE / 2 + Constants.MOUSE_SIZE / 2)
      }
      .forEach { mouse in
        mouse.state = .catched(by: cat)
      }
    }
  }

  private func broadcastGameState() async {
    let cats = (await gameState.cats).map { _, cat in
      ProtoCat(playerID: cat.id.uuidString, position: cat.position, name: cat.user.name!)
    }
    let mice = gameState.mice
      .filter { mouse in !mouse.isHidden }
      .map { mouse in
        ProtoMouse(
          mouseID: mouse.id.uuidString, position: mouse.position,
          //state: mouse.isHidden ? .hidden : (mouse.isDead ? .dead : .alive)
          state: mouse.isDead ? .dead : .alive
        )
      }
    let protoGameState = ProtoGameState(mice: mice, cats: cats)
    let update = ProtoUpdate(data: .gameCharacterState(state: protoGameState))
    await networkManager.broadcast(body: update, onlyIf: { user in user.inGame })
  }

  private func createProtoGameLayout() -> ProtoUpdate {
    let exits = gameState.tunnels.map { t in
      t.exits.map { e in ProtoExit(exitID: e.id.uuidString, position: e.position) }
    }.reduce([], +)
    return ProtoUpdate(data: .gameStart(layout: ProtoGameLayout(exits: exits)))
  }

  private func broadcastGameLayout() async {
    let update = createProtoGameLayout()
    await networkManager.broadcast(body: update, onlyIf: { user in user.inGame })
  }

  func on(action: ProtoAction, from user: User) async {
    log.info("Recognize action \(action.data) by \(user)")

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

    guard user.inGame, let cat = cat else {
      let err = ProtoError(
        code: .userNotYetJoined, message: "The user hasn't joined yet, so movement is not possible")
      return await networkManager.send(msg: err, to: user)
    }

    // set new movement direction
    cat.movement = direction
  }

  func handleLeave(from user: User) async {
    await gameState.removeCat(by: user)
  }

  private func spawnCats(from users: [User]) -> [User: Cat] {
    return users.reduce(into: [User: Cat]()) { res, u in
      res[u] = spawnCat(from: u)
    }
  }

  private func spawnCat(from user: User) -> Cat {
    let catPos = Position.random(in: 0...Double(Constants.FIELD_LENGTH))
    return Cat(id: user.id, position: catPos, user: user)
  }

  private func spawnMice(in tunnels: [Tunnel]) -> [Mouse] {
    var mice: [Mouse] = []
    var available: Set<Exit> = Set(tunnels.flatMap { $0.exits })
    let partOfTunnel = tunnels.reduce(into: [Exit: Tunnel]()) { dict, tunnel in
      for exit in tunnel.exits {
        dict[exit] = tunnel
      }
    }

    while mice.count < Constants.MICE_NUM && !available.isEmpty {
      let exit = available.randomElement()!
      available.remove(exit)
      let tunnel = partOfTunnel[exit]!
      let position = Position(position: exit.position)
      mice.append(Mouse(id: UUID(), position: position, hidesIn: tunnel))
    }

    return mice
  }
}
