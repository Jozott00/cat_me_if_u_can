//
//  WebsocketContentView.swift
//  Client
//
//  Created by Paul Pinter on 24.04.23.
//

import SwiftUI

//TODO: Remove when done with testing
struct WebsocketContentView: View {
  var body: some View {
    WebsocketInnerView()
  }
}

struct WebsocketContentView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      WebsocketInnerView()
    }
  }
}
