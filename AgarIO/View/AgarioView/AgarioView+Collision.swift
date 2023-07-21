//
//  AgarioView+Collision.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit

extension AgarioView: BallCollisionDelegate {
    func collided(with ballA: BallEntity, _ ballB: BallEntity) {
        let bigBall: BallEntity
        let smallBall: BallEntity
        let bigBallRadius: Float
        let smallBallRadius: Float
        
        guard let ballARadius = ballA.getRadius(), let ballBRadius = ballB.getRadius() else {return}
        
        bigBall = ballARadius < ballBRadius ? ballB : ballA
        smallBall = ballARadius < ballBRadius ? ballA : ballB
        bigBallRadius = bigBall.getRadius()!
        smallBallRadius = smallBall.getRadius()!
        
        bigBall.resize(bigBallRadius + smallBallRadius, relativeTo: bigBall)
        
        smallBall.runWithOwnership {result in
            switch result {
            case .success(_):
                self.session.remove(anchor: smallBall.arAnchor)
                self.scene.removeAnchor(smallBall)
            case .failure(_):
                print("Fail")
            }
        }
        
        if bigBall.ballType == .myBall,
           let score = bigBall.getScore() {
            self.gameStateManager.updateScore(
                of: self.collaborativeSession.peerID,
                score: score
            )
            let result = self.collaborativeSession.sendScoreToPeers(score, reliably: true)
            if !result {
                print("failed sharing score")
            }
        }
        
        if smallBall.ballType == .myBall {
            self.gameStateManager.gameOver()
            let result = self.collaborativeSession.sendScoreToPeers(0, reliably: true)
            if !result {
                print("failed sharing score")
            }
        }
    }
}
