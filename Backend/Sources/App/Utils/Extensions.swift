//
//  File.swift
//
//
//  Created by Johannes Zottele on 21.03.23.
//

import Foundation
import WebSocketKit

extension WebSocket: Equatable {
    public static func == (lhs: WebSocket, rhs: WebSocket) -> Bool {
        lhs === rhs
    }
}
