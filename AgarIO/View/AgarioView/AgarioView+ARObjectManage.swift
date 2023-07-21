//
//  AgarioView+ARObjectManage.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit
import ARKit

extension AgarioView: ARObjectDelegate {
    func addARObjectToARView(arObject: HasAnchoring) {
        if let myBall = isMyBall(arObject: arObject) {
//            self.installGestures(.all, for: myBall)
        }
        self.scene.addAnchor(arObject)
    }
    
    func addARAnchorToARView(arAnchor: ARAnchor) {
        self.session.add(anchor: arAnchor)
    }
    
    func isMyBall(arObject: HasAnchoring) -> BallEntity? {
        if let ballObject = arObject as? BallEntity {
            if ballObject.ballType == .myBall {
                return ballObject
            }
        }
        return nil
    }
}
