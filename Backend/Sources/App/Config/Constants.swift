//
//  Constants.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation

final class Constants {
    // game behaviour
    static let TICK_INTERVAL_MS: Double = 8.0
    static let POINTS_PER_SEC: Double = 100.0 // movement speed in seconds
    static let MOVEMENT_PER_TICK: Double = (TICK_INTERVAL_MS / 1000) * POINTS_PER_SEC // actual movement per tick

    // lobby settings
    static let JOINED_USER_START_NR = 1

    // board settings
    public static let FIELD_LENGTH: Double = 800
    static let TUNNELS_NUM = 8
    static let MICE_NUM = 10
    static let EXIT_SIZE: Double = 33
    static let MAX_EXITS = 4
    static let EXITS_MAX_DISTANCE: Double = 200
    static let EXITS_MIN_DISTANCE: Double = .init(EXIT_SIZE) * 2.5
}
