//
//  ARObjectDelegate.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit
import ARKit

protocol ARObjectDelegate {
    func addARObjectToARView(arObject: HasAnchoring)
    
    func addARAnchorToARView(arAnchor: ARAnchor)
}
