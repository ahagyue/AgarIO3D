//
//  MyBall.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit
import ARKit

class MyBall {
    private let myBall: BallEntity
    
    public var delegate: ARObjectDelegate?
    
    init() {
        let position = SIMD3<Float>(
            Config.MY_BALL_RADIUS + Config.X_OFFSET,
            Config.MY_BALL_RADIUS + Config.Y_OFFSET,
            Config.MY_BALL_RADIUS + Config.Z_OFFSET
        )
        self.myBall = BallEntity(radius: Config.MY_BALL_RADIUS, position: position)
    }
    
    func setCollision(_ collisionDelegate: BallCollisionDelegate, _ view: ARView) {
        self.myBall.collisionDelegate = collisionDelegate
        self.myBall.addCollisions()
        view.installGestures(.all, for: self.myBall)
    }
    
    func addToARView() {
        delegate?.addARObjectToARView(arObject: self.myBall)
        delegate?.addARAnchorToARView(arAnchor: self.myBall.arAnchor)
    }
    
    func getBall() -> BallEntity {
        return myBall
    }
    
    func move(_ movable: Movable) {
        movable.move(hasAnchoring: self.myBall)
    }
}
