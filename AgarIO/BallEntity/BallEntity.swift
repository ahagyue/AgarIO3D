//
//  BallEntity.swift
//  AGARIO
//
//  Created by JMT on 2023/06/20.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

public enum MHelperErrors: Error {
  case timedOut
  case failure
}

enum BallType: String {
    case myBall = "myBall"
    case feed = "feed"
    case none = "none"
}

class BallEntity: Entity, HasModel, HasCollision, HasAnchoring {
    var arAnchor: ARAnchor
    
    var collisionDelegate: BallCollisionDelegate?
    var collisionSubs: [Cancellable] = []
    
    let ballType: BallType
    
    required init(
        radius: Float,
        material: SimpleMaterial,
        ballType: BallType,
        position: SIMD3<Float>
    ) {
        self.ballType = ballType
        self.arAnchor = ARAnchor(
            transform: simd_float4x4(
                SIMD4<Float>(1, 0, 0, 0),
                SIMD4<Float>(0, 1, 0, 0),
                SIMD4<Float>(0, 0, 1, 0),
                SIMD4<Float>(position.x, position.y, position.z, 1)
            )
        )
        
        super.init()
        
        self.anchoring = AnchoringComponent(self.arAnchor)
        self.synchronization?.ownershipTransferMode = .autoAccept
        
        let shape = ShapeResource.generateSphere(radius: radius)
        let mesh = MeshResource.generateSphere(radius: radius)
        
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [shape],
            mode: .trigger,
            filter: .sensor
        )
        
        self.components[ModelComponent.self] = ModelComponent(
            mesh: mesh,
            materials: [material]
        )
    }
    
    convenience init(
        radius: Float,
        position: SIMD3<Float>,
        material: SimpleMaterial = SimpleMaterial(),
        ballType: BallType = .myBall
    ) {
        self.init(radius: radius, material: material, ballType: ballType, position: position)
    }
    
    func getRadius() -> Float? {
        guard let boundingBoxRadius = self.components[ModelComponent.self]?.mesh.bounds.boundingRadius
        else {return nil}
        return boundingBoxRadius * length(self.scale) / 3
    }
    
    func getScore() -> Float? {
        guard let score = self.getRadius() else { return nil }
        return score / Config.MY_BALL_RADIUS
    }
    
    required init() {
        self.ballType = .none
        self.arAnchor = ARAnchor(transform: Transform().matrix)

        super.init()
    }
}

extension BallEntity {
    func runWithOwnership(
        completion: @escaping (Result<HasSynchronization, Error>) -> Void
    ) {
        if self.isOwner {
            completion(.success(self))
        } else {
            self.requestOwnership { (result) in
                if result == .granted {
                    completion(.success(self))
                } else {
                    completion(
                        .failure(result == .timedOut ?
                                 MHelperErrors.timedOut :
                                    MHelperErrors.failure
                                )
                    )
                }
            }
        }
    }
}
