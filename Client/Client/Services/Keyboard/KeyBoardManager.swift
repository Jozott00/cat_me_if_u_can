//
//  KeyDetection.swift
//  Client
//
//  Created by Paul Pinter on 30.04.23.
//  Inspired by https://gist.github.com/chipjarred/e39c48619e591fbf9588af3d3684bed9

import CoreGraphics
import Foundation
import Shared
import SwiftUI

class KeyboardManager {
  static let data = GameSession.data
  // higher polling times reduce cpu load
  private static let pollingInterval: DispatchTimeInterval = .microseconds(100)
  // queue for polling
  private static let pollingQueue = DispatchQueue.main
  // controlls for start and stop state
  private static var isPollingActive = false

  private static var toneSupressMointor: Any?

  /// Starts keyboard polling
  static func start() {
    isPollingActive = true
    scheduleNextPoll(on: pollingQueue)
  }
  /// Stops keyboard polling
  static func stop() {
    isPollingActive = false
  }

  static func disableAlertToneAndKeyboardInput() {
    DispatchQueue.main.async {
      if toneSupressMointor != nil {
        return
      }
      toneSupressMointor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in return nil }
    }
  }

  static func endableAlertToneAndKeyboardInput() {
    DispatchQueue.main.async {
      guard let toneSupressMointor = toneSupressMointor else {
        return
      }

      NSEvent.removeMonitor(toneSupressMointor)
      self.toneSupressMointor = nil
    }
  }

  // snapshot of pressed keys during polling intervall
  static var keyStates: [CGKeyCode: Bool] = [
    .kVK_UpArrow: false,
    .kVK_DownArrow: false,
    .kVK_LeftArrow: false,
    .kVK_RightArrow: false,
  ]
  /// continues polling
  private static func scheduleNextPoll(on queue: DispatchQueue) {
    queue.asyncAfter(deadline: .now() + pollingInterval) {
      pollKeyStates()
    }
  }
  private static func pollKeyStates() {
    // iterates through all observed keys that are tracked
    for (code, _) in keyStates {
      keyStates[code] = code.isPressed
    }
    let currentDirection = calculateDirection()
    // only tell the server if there is a directional change
    if currentDirection != data.playerDirection {
      data.playerDirection = currentDirection
      GameSession.move(direction: currentDirection)
    }
    // continue if not the stop signal wasn't send
    if isPollingActive {
      scheduleNextPoll(on: pollingQueue)
    }
  }
  /// calculates direction based on keys state
  private static func calculateDirection() -> ProtoDirection {
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
