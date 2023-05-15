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

  private var synced = Sync()

  init(game: GameController, networkManager: NetworkManager) {
    self.game = game
    self.networkManager = networkManager
    networkManager.delegates.append(self)
  }

  /// starts the game in new thread
  private func startGame() {
    gameRunning = true

    Task {
      // start game
      let finalState = await self.game.startGame(users: self.joinedUsers.plain)

      if let finalState = finalState {
        // broadcast game end notification + game stats
        await broadcastGameEnd(state: finalState)
      }

      self.gameRunning = false
      log.info("Game stopped!")
    }
  }

  private func onStartRequest(by user: User) async {
    guard joinedUsers.contains(where: { u in u == user }) else {
      await networkManager.send(
        msg: ProtoError(
          code: .userNotYetJoined,
          message: "You cannot start the game since you didn't join the lobby yet."),
        to: user
      )
      return
    }

    // check if game shell be started in synchronized block
    await synced.run {
      // check if game already running
      guard !self.gameRunning else {
        await networkManager.send(
          msg: ProtoError(
            code: .gameAlreadyStarted,
            message: "You cannot start the game since it is already running."),
          to: user
        )
        return
      }

      // check if number of users is enough
      guard self.joinedUsers.count >= Constants.JOINED_USER_START_NR else {
        await networkManager.send(
          msg: ProtoError(
            code: .notEnoughPlayers,
            message: "You cannot start the game since there are not enough players in the lobby."),
          to: user
        )
        return
      }

      self.startGame()
    }
  }

  private func onJoin(user: User, name: String) async {
    guard !joinedUsers.contains(where: { u in u == user }) else {
      let err = ProtoError(code: .alreadyJoined, message: "You already joined the gamelobby!")
      return await networkManager.send(msg: err, to: user)
    }

    user.name = name
    joinedUsers.append(user)

    if gameRunning {
      await game.hotJoin(user: user)
    }

    // send client join ack
    let ack = ProtoUpdate(data: .joinAck(id: user.id.uuidString))
    await networkManager.send(msg: ack, to: user)

    // let other people know that new user joined the lobby
    await broadcastLobbyUpdate()
  }

  /// checks if the game should be stopped
  ///
  /// e.g. because of too few players
  private func checkForStopGame() {
    guard gameRunning else { return }
    guard joinedUsers.count < Constants.JOINED_USER_START_NR else { return }
    game.stopGame()
  }

  private func onLeave(user: User) async {
    joinedUsers.removeAll { u in u == user }
    checkForStopGame()
    await broadcastLobbyUpdate()
  }

  private func broadcastGameEnd(state: GameState) async {
    let scoreboard = await game.createProtoScoreBoard(state: state)
    let update = ProtoUpdateData.gameEnd(score: scoreboard)
    let body = ProtoUpdate(data: update)
    await networkManager.broadcast(body: body, onlyIf: { u in u.inGame == true })
  }

  private func broadcastLobbyUpdate() async {
    let protoUsers = joinedUsers.plain.map { u in ProtoUser(id: u.id.uuidString, name: u.name!) }
    let lobbyUpdate = ProtoUpdate(
      data:
        .lobbyUpdate(users: protoUsers, gameRunning: gameRunning)
    )

    await networkManager.broadcast(body: lobbyUpdate)
  }

  func on(action: ProtoAction, from user: User) async {
    switch action.data {
    case let .join(username: username):
      await onJoin(user: user, name: username)
    case .leave:
      await onLeave(user: user)
    case .startGame:
      await onStartRequest(by: user)
    default:
      // do nothing
      break
    }
  }
}
