//
//  Constants.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation

final class Constants {
  // core game behaviour
  static let TICK_INTERVAL_MS: UInt64 = 8

  // lobby settings
  static let JOINED_USER_START_NR = 1

  // cats (player)
  static let CAT_SIZE: Double = 33
  static let CAT_POINTS_PER_SEC: Double = 280.0  // movement speed in seconds
  static let CAT_MOVEMENT_PER_TICK: Double =
    (Double(TICK_INTERVAL_MS) / 1000) * CAT_POINTS_PER_SEC  // actual movement per tick

  // mice (NPCs)
  static let MICE_NUM = 20
  static let MOUSE_SIZE: Double = 33
  static let MOUSE_MOVEMENT_PER_TICK: Double = CAT_MOVEMENT_PER_TICK * 0.2

  // board settings
  public static let FIELD_LENGTH: Double = 800
  static let TUNNELS_NUM = 7
  static let EXIT_SIZE: Double = 33
  static let MAX_EXITS = 4  // Upper limit of exists a tunnel can have
  static let EXITS_MAX_DISTANCE: Double = 250  // THe maximum two exists can be apart from the same tunnel
  static let EXITS_MIN_DISTANCE: Double = .init(EXIT_SIZE) * 2  // The minimum two exits mus be apart
}
