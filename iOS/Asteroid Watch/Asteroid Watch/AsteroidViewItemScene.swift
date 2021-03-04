import SpriteKit
import AsteroidWatchAPI

public class AsteroidViewItemScene: SKScene {
    
    var asteroid: Asteroid?
        
    public override init() {
        super.init()
        self.scaleMode = .fill
    }
    
    public override init(size: CGSize) {
        super.init(size: size)
    }
    
    public convenience init(asteroid: Asteroid) {
        self.init(fileNamed: "AsteroidViewItemScene2")!
        self.asteroid = asteroid
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addStars() {
        let parent = SKNode()
        for _ in 0..<Int.random(in: 10...100) {
            let node: SKShapeNode = .init(
                circleOfRadius: CGFloat.random(in: 0.1..<3)
            )
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
        self.backgroundColor = .clear
        
        guard let asteroid = asteroid else { return }
        
        //addStars()
        
        let asteroidTemplate = (childNode(withName: "asteroid") as? SKSpriteNode)!
        
        asteroidTemplate.removeFromParent()
        
        let asteroidNode: SKShapeNode = asteroid.visualNode.node2D ?? AsteroidGenerator.generateAsteroid(
            size: asteroidTemplate.size
        ) ?? SKShapeNode()
        
        asteroidNode.zPosition = -1
        asteroidNode.position = .init(
            x: asteroidTemplate.position.x - asteroidNode.frame.width/2,
            y: asteroidTemplate.position.y - asteroidNode.frame.height/2
        )
        addChild(asteroidNode)
        
        (childNode(withName: "name") as? SKLabelNode)?.text = asteroid.name
        (childNode(withName: "velocity") as? SKLabelNode)?.text = "\(numberFormatter.string(from: NSNumber(value: Int(asteroid.velocity)))!) km/h"
        (childNode(withName: "miss_distance") as? SKLabelNode)?.text = "\(numberFormatter.string(from: NSNumber(value: Int(asteroid.missDistance)))!) km"
        (childNode(withName: "diameter") as? SKLabelNode)?.text = "\(numberFormatter.string(from: NSNumber(value: Int(asteroid.diameter)))!) m"
        (childNode(withName: "alert") as? SKSpriteNode)?.alpha = asteroid.isHazardous ? 1 : 0
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
}
