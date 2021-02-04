public class AsteroidViewItemScene: SKScene {
    
    var asteroids: [VisualAsteroid] = []
        
    public override init() {
        super.init()
    }
    
    public convenience init(asteroids: [Asteroid]) {
        self.init()
        self.asteroids = asteroids.map {
            VisualAsteroid(asteroid: $0, shapeNode: AsteroidGenerator.generateAsteroid() ?? SKShapeNode())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
