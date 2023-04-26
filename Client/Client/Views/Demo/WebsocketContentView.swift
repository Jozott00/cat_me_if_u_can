//
//  WebsocketContentView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

struct WebsocketContentView: View {
  @StateObject var data: GameData = GameData()
  @StateObject var game: GameSession = GameSession()
  var body: some View {
    WebsocketInnerView().environmentObject(game).environmentObject(data)
  }
}
