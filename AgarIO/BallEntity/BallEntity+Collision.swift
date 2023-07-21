//
//  BallEntity+Collision.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit

extension BallEntity {
    func addCollisions() {
        guard let scene = self.scene else {
          return
        }

        collisionSubs.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            print("here")
            guard let ballA = event.entityA as? BallEntity else {
                return
            }
            guard let ballB = event.entityB as? BallEntity else {
                return
            }
            
            self.collisionDelegate?.collided(with: ballA, ballB)
        })
    }
}
