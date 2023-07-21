//
//  GameStateView.swift
//  AgarIO
//
//  Created by JMT on 2023/07/20.
//

import SwiftUI

struct GameStateView: View {
    @EnvironmentObject var gameState: GameState
    var body: some View {
        if gameState.gameFinished {
            Text(gameState.gameStateString)
                .padding(10)
                .padding(.horizontal, 20)
                .foregroundColor(Color.white)
                .background(Color.black.opacity(0.5))
                .font(.system(size: 32))
        } else {
            HStack {
                VStack {
                    Text("Score Board")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.bottom, 20)
                    Text(gameState.gameStateString)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(10)
                .foregroundColor(Color.white)
                .background(Color.black.opacity(0.5))
                Spacer()
            }
        }
    }
}

struct GameStateView_Previews: PreviewProvider {
    static var previews: some View {
        GameStateView()
    }
}
