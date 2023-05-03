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
        let action = ProtoAction(data: .join(username: "MyName"))
        let msg = ProtocolMsg(type: .action(action: action), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Action.Join")
    }

    func test_produceActionJson_withLeave() throws {
        let action = ProtoAction(data: .leave)
        let msg = ProtocolMsg(type: .action(action: action), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Action.Leave")
    }

    func test_produceActionJson_startGame() throws {
        let action = ProtoAction(data: .startGame)
        let msg = ProtocolMsg(type: .action(action: action), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Action.StartGame")
    }

    func test_produceJSON_UpdateGameState() throws {
        let update = ProtoUpdate(data: .gameCharacterState(state: ProtoGameState(mice: [], cats: [])))
        let msg = ProtocolMsg(type: .update(update: update), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Update.State")
    }

    func test_produceJSON_UpdateGameStart() throws {
        let update = ProtoUpdate(data: .gameStart(layout: ProtoGameLayout(exits: [])))
        let msg = ProtocolMsg(type: .update(update: update), timestamp: Date().timeIntervalSince1970)
        try printMsgDemo(msg: msg, desc: "Msg.Update.GameStart")
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
