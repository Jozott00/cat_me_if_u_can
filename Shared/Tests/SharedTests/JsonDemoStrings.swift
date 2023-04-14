//
//  File.swift
//
//
//  Created by Johannes Zottele on 14.04.23.
//

import Foundation
@testable import Shared
import XCTest

final class JsonDemoStrings: XCTestCase {
    func test_produceActionJson_withMoveDirection() throws {
        let action = ProtoAction(data: .move(direction: .north))
        let msg = ProtocolMsg(type: .action(action: action), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Action.Move.North")
    }

    func test_produceActionJson_withJoin() throws {
        let action = ProtoAction(data: .join)
        let msg = ProtocolMsg(type: .action(action: action), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Action.Join")
    }

    func test_produceActionJson_withLeave() throws {
        let action = ProtoAction(data: .leave)
        let msg = ProtocolMsg(type: .action(action: action), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Action.Leave")
    }

    func test_produceJSON_UpdateState() throws {
        let update = ProtoUpdate(data: .gameState(state: ProtoGameState(mice: [], cats: [], exits: [])))
        let msg = ProtocolMsg(type: .update(update: update), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Update.State")
    }

    private func printMsgDemo(msg: ProtocolMsg, desc: String) throws {
        let encoder = JSONEncoder()
        let rawJson = try encoder.encode(msg)
        encoder.outputFormatting = .prettyPrinted
        let prettyJson = try encoder.encode(msg)

        print("--------------------")
        print("\(desc): \n\nRaw Version:")
        print(String(data: rawJson, encoding: .utf8)!)
        print("\n\n Pretty Version:")
        print(String(data: prettyJson, encoding: .utf8)!)
        print("--------------------")
    }
}
