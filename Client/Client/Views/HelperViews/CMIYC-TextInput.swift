//
//  CMIYC-TextInput.swift
//  Client
//
//  Created by Tim Dirr on 17.04.23.
//

import SwiftUI

struct CMIYC_TextInput: View {
    @Binding var username: String
    var body: some View {
        TextField(
            "User name",
            text: $username
        )
    }
}

struct CMIYC_TextInput_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper("Test Username") { CMIYC_TextInput(username: $0) }
    }
}
