//
//  GameView.swift
//  AgarIO
//
//  Created by JMT on 2023/07/20.
//

import ARKit
import SwiftUI
import RealityKit

struct GameView : View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var moveButton: MoveButtons
    let nick: String
    
    var body: some View {
        AgarioViewContainer(nick: nick)
            .environmentObject(gameState)
            .environmentObject(moveButton)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Spacer()
                    GameStateView()
                        .environmentObject(gameState)
                        .padding(20)
                    Spacer()
                    JoyStick()
                }
        )
    }
}

#if DEBUG
struct GameView_Previews : PreviewProvider {
    static var previews: some View {
        GameView(nick: "mm")
            .environmentObject(GameState())
            .environmentObject(MoveButtons())
    }
}
#endif
