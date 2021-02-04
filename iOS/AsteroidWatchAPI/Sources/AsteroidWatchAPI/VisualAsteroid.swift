public struct VisualAsteroid {
    let asteroid: Asteroid
    let shapeNode: SKShapeNode
    
    public init(asteroid: Asteroid, shapeNode: SKShapeNode) {
        self.asteroid = asteroid
        self.shapeNode = shapeNode
    }
}
