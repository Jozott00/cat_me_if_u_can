//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation

public struct ProtoAction: Codable {
    public let data: ProtoActionData

    public init(data: ProtoActionData) {
        self.data = data
    }
}

public enum ProtoActionData: Codable {
    case move(direction: ProtoDirection)
    case leave
    case join(username: String)
}

public enum ProtoActionType: String, Codable {
    case move
    case leave
    case join
}

public enum ProtoDirection: String, Codable {
    case north
    case south
    case east
    case west
    case northeast
    case northwest
    case southeast
    case southwest
    case stay

    public var vector: Vector2 {
        switch self {
        case .north:
            return Vector2(0, -1)
        case .south:
            return Vector2(0, 1)
        case .east:
            return Vector2(1, 0)
        case .west:
            return Vector2(-1, 0)
        case .northeast:
            return Vector2(1, -1).normalized
        case .northwest:
            return Vector2(-1, -1).normalized
        case .southeast:
            return Vector2(1, 1).normalized
        case .southwest:
            return Vector2(-1, 1).normalized
        case .stay:
            return Vector2(0, 0)
        }
    }
}
