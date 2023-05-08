//
//  CGKeyCodeExtesion.swift
//  Client
//
//  Created by Paul Pinter on 30.04.23.
//

import Carbon
import CoreGraphics
import Foundation

/// Adds pressed state
/// and commenly used key codes
/// For a complete list of key codes look at
/// https://eastmanreference.com/complete-list-of-applescript-key-codes
extension CGKeyCode {
  //CGKeyCodeKeyC
  static let kVK_UpArrow: CGKeyCode = 0x7E
  static let kVK_DownArrow: CGKeyCode = 0x7D
  static let kVK_LeftArrow: CGKeyCode = 0x7B
  static let kVK_RightArrow: CGKeyCode = 0x7C

  var isPressed: Bool {
    CGEventSource.keyState(.combinedSessionState, key: self)
  }
}
