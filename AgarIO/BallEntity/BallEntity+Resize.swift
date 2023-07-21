//
//  BallEntity+Resize.swift
//  AgarIO
//
//  Created by JMT on 2023/07/19.
//

import RealityKit

extension BallEntity {
    func resize(_ newRadius: Float, relativeTo: Entity?) {
        guard let radius = self.getRadius() else { return }
        self.setScale(SIMD3(repeating: newRadius / radius), relativeTo: relativeTo)
    }
}
