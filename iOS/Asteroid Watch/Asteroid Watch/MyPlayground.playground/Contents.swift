import PlaygroundSupport
import SpriteKit

extension SKScene {
    func addChildren(_ children: [SKNode]) {
        for child in children {
            addChild(child)
        }
    }
}

let view = SKView(
    frame: .init(
        origin: .init(),
        size: CGSize(
            width: 600,
            height: 600
        )
    )
)

PlaygroundPage.current.liveView = view

class GameScene: SKScene {
    override func update(_ currentTime: TimeInterval) {
        removeAllChildren()
        let points: [SKShapeNode] = (1...10).map { _ in
            SKShapeNode(
                circleOfRadius: 5
            )
        }.map {
            let w = size.width / 2
            let h = size.height / 2
            $0.position = CGPoint(
                x: .random(
                    in: (
                        -w + $0.frame.width/2)...(w - $0.frame.width/2
                    )
                ),
                y: .random(
                    in: (
                        -h + $0.frame.height/2)...(h - $0.frame.height/2
                    )
                )
            )
            return $0
        }
        addChildren(points)
    }
}

let scene: GameScene = {
    let scene = GameScene(size: view.frame.size)
    scene.anchorPoint = .init(x: 0.5, y: 0.5)
    return scene
}()

//view.presentScene(scene)
