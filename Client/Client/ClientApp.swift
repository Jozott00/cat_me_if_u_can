//
//  ClientApp.swift
//  Client
//
//  Created by Johannes Zottele on 12.04.23.
//

import SwiftUI

@main
struct ClientApp: App {
  var body: some Scene {
    WindowGroup {
      // WebsocketContentView()
      MainView()
        .onDisappear {
          GameSession.stop()
        }
        .navigationTitle("Cat me if you can")
    }
  }
}
