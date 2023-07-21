//
//  GameStateManager.swift
//  AgarIO
//
//  Created by JMT on 2023/07/20.
//

import MultipeerConnectivity

class GameStateManager {
    let gameState: GameState
    
    init (gameState: GameState) {
        self.gameState = gameState
    }
    
    func addPlayer(peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.gameState.player.append(
                Player(
                    peerID: peerID,
                    score: 1.0
                )
            )
            self.updateScoreBoard()
        }
    }
    
    func removePlayer(peerID: MCPeerID) {
        guard let idx = findWithPeerID(peerID) else { return }
        DispatchQueue.main.async {
            self.gameState.player.remove(at: idx)
            self.updateScoreBoard()
        }
    }
    
    func updateScore(of peerID: MCPeerID, score: Float) {
        guard let idx = findWithPeerID(peerID) else { return }
        DispatchQueue.main.async {
            self.gameState.player[idx].score = score
            self.updateScoreBoard()
        }
    }
    
    func gameOver() {
        DispatchQueue.main.async {
            self.gameState.gameFinished = true
        }
        self.updateGameStateString("Game Over")
    }
    
    func updateGameStateString(_ gameStateString: String) {
        DispatchQueue.main.async {
            self.gameState.gameStateString = gameStateString
        }
    }
    
    func updateScoreBoard() {
        self.updateGameStateString(self.generateScoreBoard())
    }
    
    private func generateScoreBoard() -> String {
        var gameStateString: String = ""
        
        let sortedPlayers = gameState.player.sorted(by: comparePlayer)
        for (idx, p) in sortedPlayers.enumerated() {
            if p.finished {
                continue
            }
            gameStateString += "\(idx+1). " + p.nick + " : \(roundf(p.score * 10) / 10)\n"
        }
        return gameStateString.trimmingCharacters(in: ["\n"])
    }
    
    private func findWithPeerID(_ peerID: MCPeerID) -> Int? {
        var idx = 0
        for p in gameState.player {
            if p.nick == peerID.displayName {
                break
            }
            idx += 1
        }
        
        if idx >= gameState.player.count {
            return nil
        }
        return idx
    }
}
