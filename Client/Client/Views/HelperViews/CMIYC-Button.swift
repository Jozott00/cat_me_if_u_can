//
//  CMIYC-Button.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct CMIYC_Button: View {
  @Binding var lable: String

  var body: some View {
    Text("Button")

    // helper view for button
  }
}

struct CMIYC_Button_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper("Test Button") { CMIYC_Button(lable: $0) }
  }
}
