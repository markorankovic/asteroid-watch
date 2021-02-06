import SpriteKit
import AsteroidWatchAPI

public class AsteroidViewItemScene: SKScene {
    
    var asteroid: VisualAsteroid?
        
    public override init() {
        super.init()
        self.scaleMode = .fill
    }
    
    public override init(size: CGSize) {
        super.init(size: size)
    }
    
    public convenience init(asteroid: Asteroid) {
        self.init(fileNamed: "AsteroidViewItemScene2")!
        let asteroidNode = (childNode(withName: "asteroid") as? SKSpriteNode)!
        self.asteroid = VisualAsteroid(
            asteroid: asteroid,
            shapeNode: AsteroidGenerator.generateAsteroid(size: asteroidNode.frame.size) ?? SKShapeNode()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addStars() {
        let parent = SKNode()
        for _ in 0..<Int.random(in: 10...100) {
            let node: SKShapeNode = .init(circleOfRadius: CGFloat.random(in: 0.1..<3))
            node.position = .init(
                x: CGFloat.random(in: 0..<400) - 400/2,
                y: CGFloat.random(in: 0..<300) - 300/2
            )
            node.fillColor = .white
            node.zPosition = -2
            parent.addChild(node)
        }
        let tex = view?.texture(from: parent)
        let background = SKShapeNode(rect: frame)
        background.fillColor = .white
        background.fillTexture = tex
        addChild(background)
    }
    
    public override func didMove(to view: SKView) {
        guard let asteroid = asteroid else { return }
        
        addStars()
        
        let asteroidNode = (childNode(withName: "asteroid") as? SKSpriteNode)!
        
        asteroidNode.removeFromParent()
        asteroid.shapeNode.zPosition = -1
        asteroid.shapeNode.position = .init(x: asteroidNode.position.x - asteroid.shapeNode.frame.width/2, y: asteroidNode.position.y - asteroid.shapeNode.frame.height/2)
        addChild(asteroid.shapeNode)
        
        (childNode(withName: "name") as? SKLabelNode)?.text = asteroid.asteroid.name
        (childNode(withName: "velocity") as? SKLabelNode)?.text = "\(Int(asteroid.asteroid.velocity)) km/h"
        (childNode(withName: "miss_distance") as? SKLabelNode)?.text = "\(Int(asteroid.asteroid.missDistance)) km"
        (childNode(withName: "diameter") as? SKLabelNode)?.text = "\(Int(asteroid.asteroid.diameter)) m"
        (childNode(withName: "alert") as? SKSpriteNode)?.alpha = asteroid.asteroid.isHazardous ? 1 : 0
    }
    
}


