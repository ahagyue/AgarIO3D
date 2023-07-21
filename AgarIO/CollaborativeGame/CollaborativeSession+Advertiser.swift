//
//  CollaborativeSession+Advertiser.swift
//  AGARIO
//
//  Created by JMT on 2023/07/13.
//

import MultipeerConnectivity

extension CollaborativeSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
}
