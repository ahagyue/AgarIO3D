//
//  Config.swift
//  AGARIO
//
//  Created by JMT on 2023/06/20.
//

import Foundation

struct Config {
    static let MY_BALL_RADIUS           : Float         = 0.1
    
    static let FEED_N                   : Int           = 10
    static let FEED_SIZE_LOWER_BOUND    : Float         = 0.01
    static let FEED_SIZE_UPPER_BOUND    : Float         = 0.05
    
    static let FIELD_SIZE_X             : Float         = 1
    static let FIELD_SIZE_Y             : Float         = 1
    static let FIELD_SIZE_Z             : Float         = 2
    
    static let X_OFFSET                 : Float         = -0.1
    static let Y_OFFSET                 : Float         = -0.2
    static let Z_OFFSET                 : Float         = -0.7
    
    static let FRONT_MOVE_SPEED          : Float         = -0.01
    static let BACK_MOVE_SPEED           : Float         = 0.01
    
    static let LEFT_ROTATE_SPEED         : Float         = 0.1
    static let RIGHT_ROTATE_SPEED        : Float         = 0.1
    static let UP_ROTATE_SPEED           : Float         = 0.1
    static let DOWN_ROTATE_SPEED         : Float         = 0.1
}
