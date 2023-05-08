//
//  GameData.swift
//  Client
//
//  Created by Paul Pinter on 26.04.23.
//

import Foundation
import Shared

/// Observable that encapsulates the current game
class GameData: ObservableObject {
  @Published var gameState: ProtoGameState?
  @Published var gameLayout: ProtoGameLayout?
  @Published var playerDirection: ProtoDirection = .stay
  @Published var activeUsers: [ProtoUser]?
  @Published var scoreBoard: ProtoScoreBoard?
}
