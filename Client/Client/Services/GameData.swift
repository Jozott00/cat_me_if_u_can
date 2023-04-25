//
//  GameData.swift
//  Client
//
//  Created by Paul Pinter on 25.04.23.
//

import Foundation
import Shared

class GameData: ObservableObject {
  @Published var gameState: ProtoGameState?
  @Published var gameLayout: ProtoGameLayout?
}
