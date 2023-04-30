//
//  KeyDetection.swift
//  Client
//
//  Created by Paul Pinter on 30.04.23.
//

import CoreGraphics
import Foundation
import Shared

class KeyboardManager {
  static let keyPressOberver = KeyPressObservable()
  // higher polling times reduce cpu load
  private static let pollingInterval: DispatchTimeInterval = .seconds(1)
  private static let pollingQueue = DispatchQueue.main

  // Starts keyboard polling
  static func start() {
    scheduleNextPoll(on: pollingQueue)
  }

  static var keyStates: [CGKeyCode: Bool] = [
    .kVK_UpArrow: false,
    .kVK_DownArrow: false,
    .kVK_LeftArrow: false,
    .kVK_RightArrow: false,
  ]

  private static func scheduleNextPoll(on queue: DispatchQueue) {
    queue.asyncAfter(deadline: .now() + pollingInterval) {
      pollKeyStates()
    }
  }
  private static func pollKeyStates() {
    for (code, wasPressed) in keyStates {
      // currenthardware keyboard state
      if code.isPressed {
        // previous keyboard state stored in key state array
        if !wasPressed {
          keyStates[code] = true
        }
        else if wasPressed {
          keyStates[code] = false
        }
      }
    }
    keyPressOberver.direction = currentDirection()
    scheduleNextPoll(on: pollingQueue)
  }

  private static func currentDirection() -> ProtoDirection {
    let up = keyStates[.kVK_UpArrow] ?? false
    let down = keyStates[.kVK_DownArrow] ?? false
    let left = keyStates[.kVK_LeftArrow] ?? false
    let right = keyStates[.kVK_RightArrow] ?? false

    switch (up, down, left, right) {
      case (true, false, false, false):
        return .north
      case (false, true, false, false):
        return .south
      case (false, false, true, false):
        return .west
      case (false, false, false, true):
        return .east
      case (true, false, true, false):
        return .northwest
      case (true, false, false, true):
        return .northeast
      case (false, true, true, false):
        return .southwest
      case (false, true, false, true):
        return .southeast
      default:
        return .stay
    }
  }
}
