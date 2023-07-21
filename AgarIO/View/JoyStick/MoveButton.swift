//
//  Button.swift
//  AGARIO
//
//  Created by JMT on 2023/06/20.
//

import SwiftUI

struct MoveButton: View {
    @State private var isButtonPressed = false
    @Binding var movement: MoveButtonState
    
    private let repeatInterval = 0.01
    
    var buttonSymbol: String {
        switch movement.buttonType {
        case .frontTranslation:
            return "up"
        case .backTranslation:
            return "down"
        case .leftRotation:
            return "left"
        case .rightRotation:
            return "right"
        case .upRotation:
            return "up"
        case .downRotation:
            return "down"
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                // Start the action when the button is pressed
                isButtonPressed = true
            }, label: {
                Label(buttonSymbol, systemImage: "chevron.\(buttonSymbol).circle")
                    .font(.title)
                    .labelStyle(.iconOnly)
            })
            .onLongPressGesture(minimumDuration: 0.01, pressing: { isPressed in
                // Update the state variable when the button is pressed or released
                isButtonPressed = isPressed
                movement.pressCheck = isPressed
            }, perform: {})
        }
        .onAppear {
            // Start a timer when the view appears
            Timer.scheduledTimer(withTimeInterval: repeatInterval, repeats: true) { _ in
                // Check if the button is pressed
                if isButtonPressed {
                    // Execute your action here
                    movement.pressCheck.toggle()
                }
            }
        }
    }
}

struct MoveButton_Previews: PreviewProvider {
    static var previews: some View {
        MoveButton(movement: .constant(MoveButtonState(buttonType: .backTranslation)))
    }
}
