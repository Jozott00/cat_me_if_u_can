//
//  NetworkManagerDelegate.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation
import Shared

/// `NetworkDelegate` is a protocol that defines a method for listening to incoming
/// action messages from clients. Classes implementing this protocol act as a delegate
/// for the `NetworkManager` to handle and process incoming actions
protocol NetworkDelegate {
  /// Called when an action message is received from a client.
  ///
  /// - Parameters:
  ///   - action: A `ProtoAction` instance representing the received action message.
  ///   - from: The `User` object representing the client that sent the action.
  ///   - receivedBy: The `NetworkManager` instance that received the action.
  ///   This asynchronous method should be implemented by the delegate to handle and process
  ///   the incoming action as needed. The delegate can respond to the action, update the game state,
  ///   or perform any other required tasks.
  func on(action: ProtoAction, from: User) async
}
