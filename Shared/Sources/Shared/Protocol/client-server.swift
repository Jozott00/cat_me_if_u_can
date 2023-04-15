//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import Foundation
import simd

public typealias Vector = simd_float2

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

    var vector: Vector {
        switch self {
        case .north:
            return Vector(0, 1)
        case .south:
            return Vector(0, -1)
        case .east:
            return Vector(1, 0)
        case .west:
            return Vector(-1, 0)
        case .northeast:
            return Vector(1, 1)
        case .northwest:
            return Vector(-1, 1)
        case .southeast:
            return Vector(1, -1)
        case .southwest:
            return Vector(-1, -1)
        case .stay:
            return Vector(0, 0)
        }
    }
}
