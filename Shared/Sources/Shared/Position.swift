//
//  File.swift
//
//
//  Created by Johannes Zottele on 28.03.23.
//

import Foundation

public class Position: Codable, CustomStringConvertible, Equatable {
  public var x: Double
  public var y: Double

  public static func == (lhs: Position, rhs: Position) -> Bool {
    return rhs.x == lhs.x && rhs.y == lhs.y
  }
  public var description: String {
    return "Position(x: \(x), y: \(y))"
  }

  public init(
    x: Double,
    y: Double
  ) {
    self.x = x
    self.y = y
  }

  public init(
    position: Position
  ) {
    x = position.x
    y = position.y
  }

  public var asVector: Vector2 {
    Vector2(x, y)
  }

  /// Move the position by x and y cartesian coordinates
  public func translate(x: Double, y: Double, within: Vector2? = nil) {
    self.x += x
    self.y += y

    // if within is set, check boundaries
    if let within = within {
      self.x = min(max(self.x, 0), within.x)
      self.y = min(max(self.y, 0), within.y)
    }
  }

  /// Move the position by x and y cartesian coordinates (as vector).
  /// The optional `within` defines a board boundary ((0,0) - within) that
  /// represents the maximum movement.
  public func translate(vec: Vector2, within: Vector2? = nil) {
    translate(x: vec.x, y: vec.y, within: within)
  }

  /// Move the position by radius and angle (polar coordinates)
  public func translate(r: Double, phi: Float64, within: Vector2? = nil) {
    x += r * cos(phi)
    y += r * sin(phi)

    // if within is set, check boundaries
    if let within = within {
      x = min(max(x, 0), within.x)
      y = min(max(y, 0), within.y)
    }
  }

  public func distance(to: Position) -> Double {
    return sqrt(pow(to.x - x, 2.0) + pow(to.y - y, 2.0))
  }

  public static func random(in boundary: ClosedRange<Double>) -> Position {
    random(xIn: boundary, yIn: boundary)
  }

  public static func random(
    xIn boundaryX: ClosedRange<Double>,
    yIn boundaryY: ClosedRange<Double>
  )
    -> Position
  {
    return Position(x: Double.random(in: boundaryX), y: Double.random(in: boundaryY))
  }
}
