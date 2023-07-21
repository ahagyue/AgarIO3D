//
//  PlayerState.swift
//  AgarIO
//
//  Created by JMT on 2023/07/20.
//

import Foundation

final class GameState: ObservableObject {
    @Published var gameStarted: Bool = false
    @Published var gameFinished: Bool = false
    @Published var gameStateString: String = ""
    @Published var player: [Player] = []
}
