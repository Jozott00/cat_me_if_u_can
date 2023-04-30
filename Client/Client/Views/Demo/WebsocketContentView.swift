//
//  WebsocketContentView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

struct WebsocketContentView: View {
  var body: some View {
    WebsocketInnerView().environmentObject(GameSession.data)
  }
}
