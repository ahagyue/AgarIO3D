//
//  BallCollisionDelegate.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit

protocol BallCollisionDelegate {
    func collided(with ballA: BallEntity, _ ballB: BallEntity)
}
