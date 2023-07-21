//
//  Player.swift
//  AgarIO
//
//  Created by JMT on 2023/07/20.
//

import MultipeerConnectivity

struct Player {
    let peerID: MCPeerID
    var nick: String {
        return peerID.displayName
    }
    var score: Float
    var finished: Bool = false
}

func comparePlayer(_ p1: Player, _ p2: Player) -> Bool {
    return p1.score < p2.score
}
