//
//  AgarioView.swift
//  AGARIO
//
//  Created by JMT on 2023/07/17.
//

import RealityKit
import ARKit
import MultipeerConnectivity

class AgarioView: ARView {
    // referring to @EnvironmentObject
    var gameState: GameState
    var moveButtonState: MoveButtons
    
    var gameStateManager: GameStateManager
    
    let myBall: MyBall
    let feeds: Feeds
    
    let nick: String
    let collaborativeSession: CollaborativeSession
    let config = ARWorldTrackingConfiguration()
    
    init(
        gameState: GameState,
        moveButtonState: MoveButtons,
        nick: String
    ) {
        self.gameState = gameState
        self.gameStateManager = GameStateManager(gameState: gameState)
        self.moveButtonState = moveButtonState
        
        self.myBall = MyBall()
        self.feeds = Feeds()
        
        self.nick = nick
        self.collaborativeSession = CollaborativeSession(
            gameStateManager: gameStateManager,
            nick: self.nick
        )
        
        super.init(frame: .zero)
        
        self.setConfig()
        self.setARView()
        self.setARObject()
    }
    
    func setConfig() {
        config.isCollaborationEnabled = true
    }
    
    func setARView() {
        self.session.run(config)
        self.scene.synchronizationService = try? MultipeerConnectivityService(
            session: collaborativeSession.session
        )
    }
    
    func setARObject() {
        self.myBall.delegate = self
        self.myBall.addToARView()
        self.myBall.setCollision(self, self)
        
        self.feeds.delegate = self
        self.feeds.addToARView()
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
}
