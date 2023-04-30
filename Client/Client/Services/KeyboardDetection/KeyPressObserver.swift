//
//  KeyPressObersvable.swift
//  Client
//
//  Created by Paul Pinter on 30.04.23.
//

import Foundation

/// Tracks wheter a key is pressed or not
class KeyPressObservable: ObservableObject {
  @Published var isUpArrowPressed: Bool = false
  @Published var isDownArrowPressed: Bool = false
  @Published var isLeftArrowPressed: Bool = false
  @Published var isRightArrowPressed: Bool = false
}
