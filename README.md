# 0.  AgarIO?

 agario라는 게임은 multiplayer online game(MO game)으로 원 모양의 자기 캐릭터(세포라고 부름)를 지키면서 키워나가는 게임입니다. 일반적으로 먹이를 먹으면서 성장하고 자신보다 크기가 작은 다른 유저의 세포를 먹어 성장할 수도 있습니다.

 이번 프로젝트는 3D agario 게임을 만드는 것입니다. agario 게임을 선택한 이유는 AR Framework인 RealityKit에서 제공하는 Collaborative AR session을 가장 잘 활용할 수 있는 게임이라 선택하게 되었습니다. 이 게임은 multiplayer AR game으로 user 간의 AR Entity 생성, 삭제가 동기화되어야 하고 이 때 Collaborative AR Session 기능을 사용하게 됩니다.

agar.io github repository: 

[GitHub - owenashurst/agar.io-clone: Agar.io clone written with Socket.IO and HTML5 canvas](https://github.com/owenashurst/agar.io-clone/tree/master)

# 1. Prerequisite

## 1.1. Collaborative AR Session

- setting하기
    
     RealityKit / ARKit에서는 Multiuser AR App 을 간편히 만들 수 있는 기능을 제공합니다. (RealityKit에서 설정이 더 간단합니다.)
    
     Swift에서 제공하는 Multipeer Connectivity Framework를 사용하여 user가 같은 network layer상에 있도록 설정 한 후 아래와 같은 코드로 ARSession에서 collaboration이 되도록 설정하고 (코드 (1)) 연결된 device의 모든 communication을 관리하는 MCSession 객체를 synchronizationService에 할당하면 (코드 (2)) ARWorldMap 및 ARAnchor의 Synchronization이 일어납니다.
    
    ```swift
    let arView = ARView()
    
    let config = ARWorldTrackingConfiguration()
    // collaborative session 설정
    config.isCollaborationEnabled = true // (1)
    arView.session.run(config)
    
    // realitykit을 사용하는 경우
    arView.scene.synchronizationService = try? MultipeerConnectivityService(
        session: {MCSession 객체}
    ) // (2)
    
    // realitykit을 사용하지 않으면 
    // ARSessionDelegate을 상속하는 class에 아래 code를 추가해야 함.
    
    // output ARCollaborationData
    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
    	do {
    		try self.mpcSession.send(data.data, toPeers: self.PeerIds, with: .reliable)
    	} catch {}
    }
    
    // receiving collaboration data
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    	self.arSession.update(data: ARSession.CollaborationData(data: data)
    }
    ```
    

- ARSession과 MCSession 내부적으로는 다음과 같은 작업이 일어납니다.
    1. MCSession을 통해 user들의 ARWorldMap 정보가 공유됩니다.
    2. ARWorldMap이 External Map에 쌓이다가 해당 정보를 바탕으로 user간의 위치가 파악이 되면 synchronization이 일어납니다.
    3.  다른 user에 대한 자신의 상대적 위치가 파악이 되면 ARAnchor가 공유됩니다.
        - synchronized lifetime (생성, 삭제 동기화)
        - session identifier (누가 생성, 삭제했는지 알 수 있음)
        - subclass ARAnchors are not shared ( ex. ARImageAnchor, ARPlaneAnchor, ARObjectAnchor, …)
            
            → attach user data to corresponding entity component.
            

- 소유권
    
    Collaborative AR Session에는 소유권이라는 개념이 있습니다. Anchor를 처음 생성한 peer에게 해당 Anchor를 조작할 수 있는 소유권이라는 것이 생깁니다. 다른 peer가 Anchor를 조작하면 자신의 화면에서는 바뀌지만 다른 peer의 화면에서는 바뀌지 않습니다.따라서 소유권을 요청하고 조작해야 합니다. 소유권을 요청하는 코드는 아래와 같습니다.
    
    ```swift
    extension BallEntity {
        func runWithOwnership(
            completion: @escaping (Result<HasSynchronization, Error>) -> Void
        ) {
            if self.isOwner {
                completion(.success(self))
            } else {
                self.requestOwnership { (result) in
                    if result == .granted {
                        completion(.success(self))
                    } else {
                        completion(
                            .failure(result == .timedOut ?
                                     MHelperErrors.timedOut :
                                        MHelperErrors.failure
                                    )
                        )
                    }
                }
            }
        }
    }
    ```
    

## 1.2. Multipeer Connectivity

Multipeer Connectivity는 peer-to-peer connectivity 및 근처 디바이스 탐색을 관장하는 framework입니다. 아래 코드는 3D Agario 코드의 일부를 발췌한 것으로 다음과 같이 Multipeer Connectivity 설정이 이뤄집니다.

1. Multipeer Session에서 MCPeerID는 해당 peer를 대표하는 객체로 자신의 MCPeerID를 생성합니다. 추후에 다룰 MCSession, MCNearbyServiceAdvertiser, MCNearbyServiceBrowser 객체에 생성 인자로 넘겨줘야 합니다.
2. 연결된 디바이스 사이에 communication을 관리하는 MCSession 객체를 생성합니다. 이 객체가 Code 1.-(2)에서 사용되는 객체입니다.
3. MCNearbyServiceAdvertiser 객체는 같은 serviceType을 갖는 session에 참여하고자 하는 신호를 보냅니다.
4. MCNearbyServiceBrowser 객체는 같은 serviceType을 갖고 참여하려는 디바이스들을 탐색합니다.

```swift
self.peerID = MCPeerID(displayName: self.displayName) // 1.
self.session = MCSession(
    peer: self.peerID,
    securityIdentity: nil,
    encryptionPreference: .required
) // 2.

self.gameStateManager = gameStateManager

self.serviceAdvertiser = MCNearbyServiceAdvertiser(
    peer: self.peerID,
    discoveryInfo: [String : String](),
    serviceType: self.serviceName
) // 3.

self.serviceBrowser = MCNearbyServiceBrowser(
    peer: self.peerID,
    serviceType: self.serviceName
) // 4.

super.init()

self.gameStateManager.addPlayer(peerID: self.peerID)

self.session.delegate = self
self.serviceAdvertiser.delegate = self
self.serviceBrowser.delegate = self

self.serviceAdvertiser.startAdvertisingPeer() // 3.
self.serviceBrowser.startBrowsingForPeers() // 4.
```

## 1.3. Entity Collision

 3D agario에서는 먹이와 세포 혹은 세포와 세포 사이의 충돌을 감지해야 합니다. RealityKit에서는 아래 코드처럼 HasCollision protocol을 구현하는 Entity 객체에 대해서 collision 정보를 subscribe할 수 있습니다.

```swift
scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            print("here")
    guard let ballA = event.entityA as? BallEntity else {
        return
    }
    guard let ballB = event.entityB as? BallEntity else {
        return
    }
    
    self.collisionDelegate?.collided(with: ballA, ballB) // (1)
}
```

# 2. Code Review

<img src="./agario_structure.svg" />

3D agario code structure diagram

**Code Structure Diagram 기호**

- 파란색 박스  :  protocol
- 검정색 박스  :  class
- A → B         :  A가 B의 객체임
- A $-\triangleright$ B      :  A가 B를 상속/구현함
- 박스 구조
    
    ```swift
     _______________________
    | class or protocol 이름 |
    |_______________________|
    |     variable list     |
    |_______________________|
    |     function list     |
     _______________________
    ```
    

## 2.1. Preview

위 구조를 더 쉽게 보기 위해서 의미론적으로 클래스들을 그룹화하는 것이 좋습니다.

1. Multipeer Connectivity 담당  : Collaborative Session
2. 게임 관련 State들 관리             : GameStateManager
3. 게임에 필요한 ball entity 관리  : BallEntity, MyBall, Feeds, ARObjectDelegate, Movable
    - BallEntity 클래스는 구 모형을 가지면서 (HasModel), 3차원 공간에 고정되어 있고 (HasAnchoring), 객체간의 충돌을 subscribe(HasCollision)합니다.
    - MyBall과 Feed 클래스는 BallEntity 객체를 Wrapping하는 클래스입니다.
    - ARObjectDelegate은 ARObject를 Wrapping하는 클래스의 ARAnchor 및 HasAnchoring을 구현하는 object를 ARView에 추가하도록 하는 protocol입니다. AgarioView에서 MyBall과 Feeds 객체 변수가 있는데 ARObjectDelegate을 구현하는 것이 이상해보일 수 있지만, 객체 선언 코드와 ARView에 Anchor를 추가하는 코드가 분리되는 경우를 고려하여 확장성을 위해 이러한 구조를 만들었습니다.
    - Movable은 Anchor를 움직이는 Class가 구현해야할 protocol이다. 이런 구조는 anchor movement 종류의 확장성을 가진다는 장점이 있습니다.
4. ARView를 상속하는 AgarioView는 전체적인 Entity 생성, 삭제, 충돌 및 Collaborative AR Session을 총괄합니다.

## 2.2. CollaborativeSession

CollaborativeSession class는 통신과 관련한 모든 부분을 관리합니다. (Advertising, Browsing, MCSession) MultipeerConnectivity setting 관련한 부분은 Code 3.를 참고하면 됩니다. 이외에 중요한 부분은 user의 점수가 변할 때 이를 모든 peer와 송수신 하는 코드입니다.

1. MCSessionDelegate protocol은 MCSession 객체의 delegate design pattern에 쓰입니다. 이를 구현하는 함수 중 하나가 점수 데이터를 받는데 쓰입니다.
2. MCSession객체의 send 메소드를 사용하면 현재 session에 참여하는 모든 peer에게 data를 송신할 수 있습니다. 이를 활용하여 점수를 공유하는데 사용합니다.

```swift
// (1) 수신
extension CollaborativeSession: MCSessionDelegate {
	...

	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    let score = data.withUnsafeBytes { $0.load(as: Float.self) }
    self.gameStateManager.updateScore(of: peerID, score: score)
  }

	...
}

// (2) 송신
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
```

## 2.3. BallEntity

### 2.3.1. constructor

BallEntity constructor에서 중요한 부분은 ARAnchor객체를 생성해서 HasAnchoring protocol variable인 anchoring에 할당해주는 것(1)과 BallEntity가 MCSession을 통해서 동기화할 때 소유권 설정을 해주는 부분(2)입니다. .autoAccept로 설정하면 다른 user가 Entity의 소유권을 요청하면 자동으로 소유권을 이전해주는데 반해 .manual로 설정하면 직접 소유권을 이전해주어야 합니다. (소유권을 이전하는 코드는 Code 2.을 확인해주세요.)

```swift
self.ballType = ballType
self.arAnchor = ARAnchor(
    transform: simd_float4x4(
        SIMD4<Float>(1, 0, 0, 0),
        SIMD4<Float>(0, 1, 0, 0),
        SIMD4<Float>(0, 0, 1, 0),
        SIMD4<Float>(position.x, position.y, position.z, 1)
    )
)

super.init()

self.anchoring = AnchoringComponent(self.arAnchor) // (1)
self.synchronization?.ownershipTransferMode = .autoAccept //(2)

let shape = ShapeResource.generateSphere(radius: radius)
let mesh = MeshResource.generateSphere(radius: radius)

self.components[CollisionComponent.self] = CollisionComponent(
    shapes: [shape],
    mode: .trigger,
    filter: .sensor
) // (3)

self.components[ModelComponent.self] = ModelComponent(
    mesh: mesh,
    materials: [material]
)
```

### 2.3.2. collision

collision을 subscribe하기 위해 HasCollision을 구현하고 CollisionComponent를 생성하였습니다 (Code 6. - (3)). 그리고 Code 4.과 같이 subscribe할 수 있는 코드도 추가하였습니다. collision handling은 BallCollisionDelegate을 상속하는 클래스에서 할 수있도록 하였습니다.
