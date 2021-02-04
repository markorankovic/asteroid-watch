import PlaygroundSupport
import SpriteKit

let points = [
    CGPoint(x: -100, y: 235 / 2),
    CGPoint(x: -64, y: 323 / 2),
    CGPoint(x: -26, y: 432 / 2),
    CGPoint(x: -25, y: 341 / 2),
    CGPoint(x: -57, y: 145 / 2),
]

class GameScene: SKScene {
        
    override func didMove(to view: SKView) {
        
        let nodes: [SKShapeNode] = points.map {
            let point = SKShapeNode(circleOfRadius: 3)
            point.position = .init(x: $0.x, y: $0.y)
            let label = SKLabelNode(text: "\(point.position)")
            label.fontSize = 10
            point.addChild(label)
            return point
        }
        
        for node in nodes {
            addChild(node)
        }
        
    }
    
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = GameScene(size: sceneView.frame.size)
// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFill

scene.anchorPoint = .init(x: 0.5, y: 0.5)

// Present the scene
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
