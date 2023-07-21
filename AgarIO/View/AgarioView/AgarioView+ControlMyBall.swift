//
//  AgarioView+ControlMyBall.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit

extension AgarioView {
    func moveMyBall(_ movable: Movable) {
        self.myBall.move(movable)
    }
}
