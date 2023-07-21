//
//  CollaborativeSession+DataInteraction.swift
//  AgarIO
//
//  Created by JMT on 2023/07/20.
//

import Foundation

extension CollaborativeSession {
    public func sendScoreToPeers(_ score: Float, reliably: Bool) -> Bool {
        let data: Data = withUnsafeBytes(of: score) { Data($0) }
        do {
            try self.session.send(
                data,
                toPeers: session.connectedPeers,
                with: reliably ? .reliable : .unreliable
            )
        } catch {
            print("sending data error")
            return false
        }
        return true
    }
}

