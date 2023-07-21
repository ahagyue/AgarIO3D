//
//  MoveButtonState.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import Foundation

enum MoveButtonType: Int, CaseIterable {
    case frontTranslation = 0
    case backTranslation = 1
    
    case leftRotation = 2
    case rightRotation = 3
    case upRotation = 4
    case downRotation = 5
}

func moveKey(_ moveButtonType: MoveButtonType) -> Int {
    return moveButtonType.rawValue
}

struct MoveButtonState {
    let buttonType: MoveButtonType
    var movable: Movable {
        switch buttonType {
        case .frontTranslation:
            return FrontTranslation()
        case .backTranslation:
            return BackTranslation()
        case .leftRotation:
            return LeftRotation()
        case .rightRotation:
            return RightRotation()
        case .upRotation:
            return UpRotation()
        case .downRotation:
            return DownRotation()
        }
    }
    var pressCheck: Bool = false
}
