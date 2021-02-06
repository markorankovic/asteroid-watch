public struct VisualAsteroid {
    public let asteroid: Asteroid
    public let shapeNode: SKShapeNode
    
    public init(asteroid: Asteroid, shapeNode: SKShapeNode) {
        self.asteroid = asteroid
        self.shapeNode = shapeNode
    }
}
