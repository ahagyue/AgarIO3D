//
//  CollaborativeSession+Browser.swift
//  AGARIO
//
//  Created by JMT on 2023/07/13.
//

import MultipeerConnectivity

extension CollaborativeSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(peerID.displayName)
    }
    
    
}
