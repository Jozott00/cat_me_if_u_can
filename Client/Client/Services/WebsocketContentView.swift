//
//  WebsocketContentView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

//TODO: Remove when done with testing
struct WebsocketContentView: View {
  @StateObject var gameData = GameData()
  var body: some View {
    WebsocketInnerView().environmentObject(gameData)
  }
}

struct WebsocketContentView_Previews: PreviewProvider {
  @StateObject var gameData = GameData()
  static var previews: some View {
    VStack {
      WebsocketInnerView()
    }
  }
}
