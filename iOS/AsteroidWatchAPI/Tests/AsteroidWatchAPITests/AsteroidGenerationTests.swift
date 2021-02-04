import XCTest
import SpriteKit
import GeometryAPI

class AsteroidGenerationTests: XCTestCase {
    
    let view = SKView(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
    
    func generateCrater(rad: CGFloat) -> SKShapeNode {
        let pointSet = CGFloat(rad).randomPointsAlongRadius(count: 10)
        let shapeNode = SKShapeNode(path: pointSet.convexHull!)
        shapeNode.strokeColor = .black
        shapeNode.fillColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
        return shapeNode
    }
    
    func generateTexture() -> SKTexture? {
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .brown
        
        let maxRad = scene.size.width/2 * 0.4
        let minRad = maxRad * 0.2
        for _ in 0..<Int(CGFloat.random(in: 2...5)) {
            let crater = generateCrater(rad: CGFloat.random(in: minRad...maxRad))
            crater.position = .init(x: CGFloat.random(in: 0..<scene.size.width), y: CGFloat.random(in: 0..<scene.size.height))
            scene.addChild(crater)
        }
        
        return view.texture(from: scene)
    }
    
}
