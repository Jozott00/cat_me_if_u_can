//
//  File.swift
//
//
//  Created by Johannes Zottele on 12.04.23.
//

import CoreGraphics
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

    var vector: CGVector {
        switch self {
        case .north:
            return CGVector(dx: 0, dy: -1)
        case .south:
            return CGVector(dx: 0, dy: 1)
        case .east:
            return CGVector(dx: 1, dy: 0)
        case .west:
            return CGVector(dx: -1, dy: 0)
        case .northeast:
            return CGVector(dx: 1, dy: -1)
        case .northwest:
            return CGVector(dx: -1, dy: -1)
        case .southeast:
            return CGVector(dx: 1, dy: 1)
        case .southwest:
            return CGVector(dx: -1, dy: 1)
        case .stay:
            return CGVector(dx: 0, dy: 0)
        }
    }
}
