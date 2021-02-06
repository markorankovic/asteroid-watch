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
        self.init(fileNamed: "AsteroidViewItemScene")!
        self.asteroid = VisualAsteroid(
            asteroid: asteroid,
            shapeNode: AsteroidGenerator.generateAsteroid() ?? SKShapeNode()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func didMove(to view: SKView) {
        guard let asteroid = asteroid else { return }
        
        (childNode(withName: "name") as? SKLabelNode)?.text = asteroid.asteroid.name
        (childNode(withName: "velocity") as? SKLabelNode)?.text = "\(Int(asteroid.asteroid.velocity))"
        (childNode(withName: "miss_distance") as? SKLabelNode)?.text = "\(Int(asteroid.asteroid.missDistance)) km"
        (childNode(withName: "diameter") as? SKLabelNode)?.text = "\(Int(asteroid.asteroid.diameter)) m"
        (childNode(withName: "alert") as? SKSpriteNode)?.alpha = asteroid.asteroid.isHazardous ? 1 : 0
    }
                
}
