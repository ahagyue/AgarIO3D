//
//  Feeds.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit
import ARKit

class Feeds {
    private var feeds: [BallEntity] = []
    private let material = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
    
    public var delegate: ARObjectDelegate?
    
    init() {
        for _ in 0..<Config.FEED_N {
            let radius = Float.random(in: Config.FEED_SIZE_LOWER_BOUND...Config.FEED_SIZE_UPPER_BOUND)
            let position = randomPosition()
            let entity = BallEntity(
                radius: radius,
                position: position,
                material: material,
                ballType: .feed
            )
            feeds.append(entity)
        }
    }
    
    private func randomPosition() -> SIMD3<Float> {
        let x = Float.random(in: -Config.FIELD_SIZE_X...Config.FIELD_SIZE_X)
        let y = Float.random(in: -Config.FIELD_SIZE_Y...Config.FIELD_SIZE_Y)
        let z = Float.random(in: -Config.Z_OFFSET...Config.FIELD_SIZE_Z - Config.Z_OFFSET)
        return SIMD3<Float>(x, y, -z)
    }
    
    func addToARView() {
        guard let _delegate = self.delegate else { return }
        for feed in self.feeds {
            _delegate.addARObjectToARView(arObject: feed)
            _delegate.addARAnchorToARView(arAnchor: feed.arAnchor)
        }
    }
}
