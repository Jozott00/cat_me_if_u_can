//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

public class Position: Codable {
    var x: Int
    var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init(position: Position) {
        x = position.x
        y = position.y
    }

    // Move the position by x and y cartesian coordinates
    public func translate(x: Int, y: Int) {
        self.x += x
        self.y += y
    }

    // Move the position by radius and angle (polar coordinates)
    public func translate(r: Int, phi: Float64) {
        x += Int(Float64(r) * cos(phi))
        y += Int(Float64(r) * sin(phi))
    }

    public func distance(to: Position) -> Int64 {
        return Int64(sqrt(pow(Float64(to.x - x), 2.0) + pow(Float64(to.y - y), 2.0)))
    }
}
