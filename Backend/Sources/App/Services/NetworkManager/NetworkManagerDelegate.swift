//
//  NetworkManagerDelegate.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation
import Shared

protocol NetworkDelegate {
    func on(action: ProtoAction, from: User, receivedBy manager: NetworkManager)
}
