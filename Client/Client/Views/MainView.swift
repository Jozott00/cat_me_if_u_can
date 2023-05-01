//
//  MainView.swift
//  Client
//
//  Created by Tim Dirr on 18.04.23.
//

import Shared
import SwiftUI

struct MainView: View {
    @State private var currentView: Int = 1
    @State private var gameLayout: ProtoGameLayout = .init(exits: [
        ProtoExit(exitID: "testid1", position: Position(x: 1, y: 1)),
        ProtoExit(exitID: "testid2", position: Position(x: 100, y: 10)),
        ProtoExit(exitID: "testid3", position: Position(x: 40, y: 700)),
        ProtoExit(exitID: "testid4", position: Position(x: 390, y: 210)),
    ])
    @State private var gameState: ProtoGameState = .init(
        mice: [ProtoMouse(mouseID: "Mouse1", position: Position(x: 100, y: 10), state: "north")],
        cats: [ProtoCat(playerID: "player1", position: Position(x: 40, y: 700))]
    )

    @StateObject var data: GameData = .init()
    @StateObject var game: GameSession = .init()

    @State private var username: String = RandomTextSelector(fileName: "usernames")
        .getRandomListElement()

    var xCord: Double = 1
    var yCord: Double = 1

    // timer bit messy in structs, just for testing
    @State var timerLogic: TimerLogic!

    class TimerLogic {
        var structRef: MainView!
        var timer: Timer!

        init(
            _ structRef: MainView
        ) {
            self.structRef = structRef
            self.timer = Timer.scheduledTimer(
                timeInterval: 0.01,
                target: self,
                selector: #selector(self.timerTicked),
                userInfo: nil,
                repeats: true
            )
        }

        func stopTimer() {
            self.timer?.invalidate()
            self.structRef = nil
        }

        @objc private func timerTicked() {
            self.structRef.timerTicked()
        }
    }

    func startTimer() {
        self.timerLogic = TimerLogic(self)
    }

    func endTimer() {
        self.timerLogic.stopTimer()
    }

    mutating func timerTicked() {
        self.yCord += 1
        self.xCord += 1
        self.gameState.mice = [
            ProtoMouse(mouseID: "Mouse1", position: Position(x: self.xCord, y: self.yCord), state: "north"),
        ]
    }

    // let usernamesList: RandomTextSelector =

    var body: some View {
        // 4 main view with global navigation
        if currentView == 1 {
            LobbyView(username: $username, currentView: $currentView)
                .environmentObject(data)
                .environmentObject(game)
        }
        else if currentView == 2 {
            LoadingScreenView(
                currentView: $currentView
            )
        }
        else if currentView == 3 {
            BoardView(currentView: $currentView)
                .environmentObject(data)
                .onAppear { startTimer() }
                .onDisappear { endTimer() }
        }
        else if currentView == 4 {
            EndScreenView(currentView: $currentView)
        }
        else {
            // maybe hier noch gescheite exception einbauen, kein plan wie das mit throws functioniert in ner view
            let _ = print(UIError.NavigationError)
        }
    }
}
