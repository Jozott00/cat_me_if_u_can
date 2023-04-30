//
//  KeyDetection.swift
//  Client
//
//  Created by Paul Pinter on 30.04.23.
//

import CoreGraphics
import Foundation

extension CGKeyCode {
  //CGKeyCodeKeyCode for Space
  static let kVK_Space: CGKeyCode = 0x31

  var isPressed: Bool {
    CGEventSource.keyState(.combinedSessionState, key: self)
  }
}
class SpaceDetector: ObservableObject {
  @Published var isPressed: Bool = false
}

class KeyboardManager {
  static let spaceDetector = SpaceDetector()
  // higher polling times reduce cpu load
  private static let pollingInterval: DispatchTimeInterval = .microseconds(1000)
  private static let pollingQueue = DispatchQueue.main

  static func start() {
    scheduleNextPoll(on: pollingQueue)
  }

  static var keyStates: [CGKeyCode: Bool] = [
    .kVK_Space: false
  ]

  static func dispatchKeyDown(_ key: CGKeyCode) {
    if key == .kVK_Space {
      spaceDetector.isPressed = true
    }
  }

  static func dispatchKeyUp(_ key: CGKeyCode) {
    if key == .kVK_Space {
      spaceDetector.isPressed = false
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
