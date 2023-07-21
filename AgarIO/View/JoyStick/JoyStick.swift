//
//  JoyStick.swift
//  AGARIO
//
//  Created by JMT on 2023/06/20.
//

import SwiftUI

struct JoyStick: View {
    @EnvironmentObject var moveButtons: MoveButtons
    
    var body: some View {
        VStack{
            Spacer()
            
            HStack {
                // left part
                MoveButton(movement: $moveButtons.buttons[moveKey(.leftRotation)])
                VStack {
                    MoveButton(movement: $moveButtons.buttons[moveKey(.upRotation)])
                    MoveButton(movement: $moveButtons.buttons[moveKey(.downRotation)])
                }
                MoveButton(movement: $moveButtons.buttons[moveKey(.rightRotation)])
                
                Spacer()
                
                // right part
                VStack {
                    MoveButton(movement: $moveButtons.buttons[moveKey(.frontTranslation)])
                    MoveButton(movement: $moveButtons.buttons[moveKey(.backTranslation)])
                }
            }
            .padding()
        }
    }
}

struct JoyStick_Previews: PreviewProvider {
    static var previews: some View {
        JoyStick()
    }
}
