//
//  KeyDetection.swift
//  Client
//
//  Created by Paul Pinter on 30.04.23.
//

import CoreGraphics
import Foundation

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

  static func dispatchKeyDown(_ key: CGKeyCode) {
    if key == .kVK_UpArrow {
      keyPressOberver.isUpArrowPressed = true
    }
    else if key == .kVK_DownArrow {
      keyPressOberver.isDownArrowPressed = true
    }
    else if key == .kVK_LeftArrow {
      keyPressOberver.isLeftArrowPressed = true
    }
    else if key == .kVK_RightArrow {
      keyPressOberver.isRightArrowPressed = true
    }
  }

  static func dispatchKeyUp(_ key: CGKeyCode) {
    if key == .kVK_UpArrow {
      keyPressOberver.isUpArrowPressed = false
    }
    else if key == .kVK_DownArrow {
      keyPressOberver.isDownArrowPressed = false
    }
    else if key == .kVK_LeftArrow {
      keyPressOberver.isLeftArrowPressed = false
    }
    else if key == .kVK_RightArrow {
      keyPressOberver.isRightArrowPressed = false
    }
  }
  private static func scheduleNextPoll(on queue: DispatchQueue) {
    queue.asyncAfter(deadline: .now() + pollingInterval) {
      pollKeyStates()
    }
  }
  private static func pollKeyStates() {
    for (code, wasPressed) in keyStates {
      if code.isPressed {
        if !wasPressed {
          dispatchKeyDown(code)
          keyStates[code] = true
        }
        else if wasPressed {
          dispatchKeyUp(code)
          keyStates[code] = false
        }
      }

    }
    scheduleNextPoll(on: pollingQueue)
  }
}
