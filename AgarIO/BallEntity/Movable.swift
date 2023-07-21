//
//  Movable.swift
//  AGARIO
//
//  Created by JMT on 2023/06/20.
//

import RealityKit
import Foundation

protocol Movable {
    var buttonSymbolDirection: String { get }
    func move(hasAnchoring: HasAnchoring)
}

class FrontTranslation: Movable {
    var buttonSymbolDirection: String = "up"
    func move(hasAnchoring: HasAnchoring) {
        let translation = hasAnchoring.orientation.act(SIMD3(x: 0, y: 0, z: Config.FRONT_MOVE_SPEED))
        let transform = Transform(translation: translation)
        hasAnchoring.move(to: transform, relativeTo: hasAnchoring.anchor)
    }
}

class BackTranslation: Movable {
    var buttonSymbolDirection: String = "down"
    func move(hasAnchoring: HasAnchoring) {
        let translation = hasAnchoring.orientation.act(SIMD3(x: 0, y: 0, z: Config.BACK_MOVE_SPEED))
        let transform = Transform(translation: translation)
        hasAnchoring.move(to: transform, relativeTo: hasAnchoring.anchor)
    }
}

class UpRotation: Movable {
    var buttonSymbolDirection: String = "up"
    func move(hasAnchoring: HasAnchoring) {
        let rotation = simd_quatf(angle: Config.UP_ROTATE_SPEED, axis: [1, 0, 0])
        let transform = Transform(rotation: rotation)
        hasAnchoring.move(to: transform, relativeTo: hasAnchoring.anchor)
    }
}

class DownRotation: Movable {
    var buttonSymbolDirection: String = "down"
    func move(hasAnchoring: HasAnchoring) {
        let rotation = simd_quatf(angle: Config.DOWN_ROTATE_SPEED, axis: [-1, 0, 0])
        let transform = Transform(rotation: rotation)
        hasAnchoring.move(to: transform, relativeTo: hasAnchoring.anchor)
    }
}

class RightRotation: Movable {
    var buttonSymbolDirection: String = "right"
    func move(hasAnchoring: HasAnchoring) {
        let rotation = simd_quatf(angle: Config.RIGHT_ROTATE_SPEED, axis: [0, -1, 0])
        let transform = Transform(rotation: rotation)
        hasAnchoring.move(to: transform, relativeTo: hasAnchoring.anchor)
    }
}

class LeftRotation: Movable {
    var buttonSymbolDirection: String = "left"
    func move(hasAnchoring: HasAnchoring) {
        let rotation = simd_quatf(angle: Config.LEFT_ROTATE_SPEED, axis: [0, 1, 0])
        let transform = Transform(rotation: rotation)
        hasAnchoring.move(to: transform, relativeTo: hasAnchoring.anchor)
    }
}
