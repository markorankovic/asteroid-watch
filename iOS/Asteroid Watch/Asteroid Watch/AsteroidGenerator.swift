import SpriteKit

let view = SKView(frame: .init(x: 0, y: 0, width: 100, height: 100))

public enum AsteroidGenerator {
    
    public static func generateCrater(rad: CGFloat) -> SKShapeNode {
        let pointSet = CGFloat(rad).randomPointsAlongRadius(count: 10)
        let shapeNode = SKShapeNode(path: pointSet.convexHull!)
        shapeNode.strokeColor = .black
        shapeNode.fillColor = SKColor.init(red: 63 / 255, green: 51 / 255, blue: 5 / 255, alpha: 1)
        return shapeNode
    }
    
    public static func generateTexture() -> SKTexture? {
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = SKColor.init(red: 128 / 255, green: 80 / 255, blue: 23 / 255, alpha: 1)
        
        let maxRad = scene.size.width/2 * 0.4
        let minRad = maxRad * 0.2
        var craters: [SKShapeNode] = []
            
        for _ in 0..<Int(CGFloat.random(in: 6...11)) {
            let crater = generateCrater(rad: CGFloat.random(in: minRad...maxRad))
            crater.position = .init(x: CGFloat.random(in: 0..<scene.size.width), y: CGFloat.random(in: 0..<scene.size.height))
            if craters.filter({ crater.intersects($0) }).isEmpty {
                craters.append(crater)
                scene.addChild(crater)
            }
        }
        return view.texture(from: scene)
    }
    
    public static func generateAsteroid(size: CGSize) -> SKShapeNode? {
        let pointSet = CGSize(width: size.width, height: size.height).randomPoints(count: 10)
        guard let convexHull = pointSet.convexHull else { return nil }
        let shapeNode = SKShapeNode(path: convexHull)
        shapeNode.strokeColor = .black
        shapeNode.fillColor = .white
        shapeNode.fillTexture = generateTexture()
        return shapeNode
    }

}
