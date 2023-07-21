//
//  CollaborativeSession.swift
//  AGARIO
//
//  Created by JMT on 2023/07/13.
//

import MultipeerConnectivity

class CollaborativeSession: NSObject {
    
    let peerID: MCPeerID
    let session: MCSession
    var displayName: String
    
    let serviceAdvertiser: MCNearbyServiceAdvertiser
    let serviceBrowser: MCNearbyServiceBrowser
    
    let serviceName: String = "agario-game"
    var peerIDLookup = [String : MCPeerID]()
    
    var gameStateManager: GameStateManager
    
    init(
        gameStateManager: GameStateManager,
        nick: String
    ) {
        self.displayName = nick
        self.peerID = MCPeerID(displayName: self.displayName)
        self.session = MCSession(
            peer: self.peerID,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        
        self.gameStateManager = gameStateManager
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(
            peer: self.peerID,
            discoveryInfo: [String : String](),
            serviceType: self.serviceName
        )
        self.serviceBrowser = MCNearbyServiceBrowser(
            peer: self.peerID,
            serviceType: self.serviceName
        )
        
        super.init()
        
        self.gameStateManager.addPlayer(peerID: self.peerID)
        
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        self.session.delegate = self
        
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
    }
}
