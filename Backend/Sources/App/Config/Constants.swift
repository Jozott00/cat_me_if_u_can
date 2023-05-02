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
    public static let FIELD_LENGTH: Double = 800
    static let TUNNELS_NUM = 8
    static let EXIT_SIZE: Double = 33
    static let MAX_EXITS = 4
    static let EXITS_MAX_DISTANCE: Double = 200
    static let EXITS_MIN_DISTANCE: Double = .init(EXIT_SIZE) * 2.5
}
