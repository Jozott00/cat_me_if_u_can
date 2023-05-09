//
//  Vector2.swift
//
//
//  Created by Johannes Zottele on 20.04.23.
//

import Foundation

public struct Vector2 {
  public let x: Double
  public let y: Double

  public init(_ x: Double, _ y: Double) {
    self.x = x
    self.y = y
  }

  public init(_ x: Int, _ y: Int) {
    self.x = Double(x)
    self.y = Double(y)
  }

  public var length: Double {
    return sqrt(x * x + y * y)
  }

  public var normalized: Vector2 {
    let len = length
    return Vector2(x / len, y / len)
  }

  func scaled(by scalar: Double) -> Vector2 {
    return Vector2(x * scalar, y * scalar)
  }

  func added(to other: Vector2) -> Vector2 {
    return Vector2(x + other.x, y + other.y)
  }

  func subtracted(from other: Vector2) -> Vector2 {
    return Vector2(x - other.x, y - other.y)
  }

  public static func + (left: Vector2, right: Vector2) -> Vector2 {
    return left.added(to: right)
  }

  public static func - (left: Vector2, right: Vector2) -> Vector2 {
    return left.subtracted(from: right)
  }

  public static func * (vector: Vector2, scalar: Double) -> Vector2 {
    return vector.scaled(by: scalar)
  }

  public static func * (scalar: Double, vector: Vector2) -> Vector2 {
    return vector.scaled(by: scalar)
  }
}
