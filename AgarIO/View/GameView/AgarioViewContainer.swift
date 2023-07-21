//
//  ARView.swift
//  AGARIO
//
//  Created by JMT on 2023/06/20.
//

import RealityKit
import ARKit
import SwiftUI
import UIKit
import MultipeerConnectivity

extension Bool {
    // XOR
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}

class PrevState {
    var prevButtonState = [false, false, false, false, false, false]
    subscript(index: Int) -> Bool {
        get {
            return prevButtonState[index]
        }
        set(value) {
            prevButtonState[index] = value
        }
    }
    
    func toggleState(_ key: Int) {
        prevButtonState[key].toggle()
    }
}

struct AgarioViewContainer: UIViewRepresentable {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var moveButtonState: MoveButtons
    var prevButtonState = PrevState()
    
    let nick: String
    
    func makeUIView(context: Context) -> AgarioView {
        let arView = AgarioView(
            gameState: self.gameState,
            moveButtonState: self.moveButtonState,
            nick: nick
        )
        return arView
    }
    
    func updateUIView(_ uiView: AgarioView, context: Context) {
        for moveButton in MoveButtonType.allCases {
            let key = moveKey(moveButton)
            if moveButtonState.buttons[key].pressCheck ^ prevButtonState[key] {
                uiView.moveMyBall(moveButtonState.buttons[key].movable)
                prevButtonState.toggleState(key)
            }
        }
    }
    
}
