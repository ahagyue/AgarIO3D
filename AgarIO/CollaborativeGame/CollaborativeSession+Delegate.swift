//
//  CollaborativeSession+Delegate.swift
//  AGARIO
//
//  Created by JMT on 2023/07/13.
//

import MultipeerConnectivity

extension CollaborativeSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            self.gameStateManager.addPlayer(peerID: peerID)
            peerIDLookup[peerID.displayName] = peerID
        case .connecting:
            break
        case .notConnected:
            self.gameStateManager.removePlayer(peerID: peerID)
            peerIDLookup.removeValue(forKey: peerID.displayName)
        @unknown default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let score = data.withUnsafeBytes { $0.load(as: Float.self) }
        self.gameStateManager.updateScore(of: peerID, score: score)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(streamName)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(resourceName)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print(resourceName)
    }
    
}
