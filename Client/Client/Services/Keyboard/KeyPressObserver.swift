//
//  KeyPressObersvable.swift
//  Client
//
//  Created by Paul Pinter on 30.04.23.
//

import Foundation
import Shared

/// Tracks wheter a key is pressed or not
class KeyPressObservable: ObservableObject {
  @Published var direction: ProtoDirection = .stay
}
