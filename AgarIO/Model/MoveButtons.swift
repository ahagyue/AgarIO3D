//
//  MoveButtons.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import UIKit

final class MoveButtons: ObservableObject {
    @Published var buttons = [
        MoveButtonState(buttonType: .frontTranslation),
        MoveButtonState(buttonType: .backTranslation),
        MoveButtonState(buttonType: .leftRotation),
        MoveButtonState(buttonType: .rightRotation),
        MoveButtonState(buttonType: .upRotation),
        MoveButtonState(buttonType: .downRotation)
    ]
}
