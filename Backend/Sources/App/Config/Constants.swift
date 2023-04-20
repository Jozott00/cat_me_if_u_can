//
//  Constants.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation

final class Constants {
    // game behaviour
    static let MOVEMENT_PER_TICK: Double = 1.0
    static let TICK_INTERVAL_MS: Double = 1000.0

    // board settings
    public static let FIELD_LENGTH = 1000
    static let TUNNELS_NUM = 8
    static let EXIT_SIZE = 10
    static let MAX_EXITS = 4
    static let EXITS_MAX_DISTANCE = 100
    static let EXITS_MIN_DISTANCE = EXIT_SIZE * 2
}
