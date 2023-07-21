//
//  JoinGameView.swift
//  AgarIO
//
//  Created by JMT on 2023/07/20.
//

import SwiftUI

struct JoinGameView: View {
    @State var nick: String = ""
    @State var validNick: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TextField("Nick", text: $nick, axis: .vertical)
                    .onChange(of: nick) { newVal in
                        nick.replace(" ", with: "_")
                        validNick = nick.count >= 5 && nick.count <= 10
                    }
                    .textFieldStyle(.roundedBorder)
                    .border(validNick ? Color.black: Color.red)
                    .padding(.horizontal, 100.0)
                
                if !validNick {
                    Text("should longer than 5, shorter than 10")
                        .foregroundColor(Color.red)
                }
                
                NavigationLink("game start") {
                    GameView(nick: nick)
                }
                .disabled(!validNick)
                
                Spacer()
            }
            .background(Color.black)
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
            .environmentObject(GameState())
            .environmentObject(MoveButtons())
    }
}
