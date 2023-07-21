//
//  AppDelegate.swift
//  AGARIO
//
//  Created by JMT on 2023/06/17.
//

import SwiftUI

@main
struct AgarIOApp: App {
    @StateObject private var gameState = GameState()
    @StateObject private var moveButton = MoveButtons()

    var body: some Scene {
        WindowGroup {
            JoinGameView()
                .environmentObject(gameState)
                .environmentObject(moveButton)
        }
    }

}

