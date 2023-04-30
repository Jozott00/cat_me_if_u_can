//
//  WebsocketContentView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

struct WebsocketContentView: View {
  init() {
    // omits alert sound when pressing down keys
    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in return nil }
  }
  var body: some View {
    WebsocketInnerView().environmentObject(GameSession.data)
  }
}
