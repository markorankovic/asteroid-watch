import SpriteKit
import GeometryAPI
import AsteroidWatchAPI

let pointSet = PointSet(points: CGSize(width: 100, height: 100).randomPoints(count: 10))
let convexHull = pointSet.convexHull
let shapeNode = SKShapeNode(path: convexHull!)
shapeNode.strokeColor = .black
shapeNode.fillColor = .brown
shapeNode.frame.size
shapeNode

let pointSet2 = PointSet(points: CGFloat(50).randomPointsAlongRadius(count: 10))
let shapeNode2 = SKShapeNode(path: pointSet2.convexHull!)
shapeNode2.strokeColor = .black
shapeNode2.fillColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
shapeNode2.frame.size
shapeNode2

let view = SKView(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))

func generateCrater(rad: CGFloat) -> SKShapeNode {
    let pointSet = PointSet(points: CGFloat(rad).randomPointsAlongRadius(count: 10))
    let shapeNode = SKShapeNode(path: pointSet.convexHull!)
    shapeNode.strokeColor = .black
    shapeNode.fillColor = SKColor.init(red: 63 / 255, green: 51 / 255, blue: 5 / 255, alpha: 1)
    return shapeNode
}

func generateTexture() -> SKTexture? {
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

let tex = generateTexture()

func generateAsteroid() -> SKShapeNode? {
    let pointSet = PointSet(points: CGSize(width: 100, height: 100).randomPoints(count: 10))
    guard let convexHull = pointSet.convexHull else { return nil }
    let shapeNode = SKShapeNode(path: convexHull)
    shapeNode.strokeColor = .black
    shapeNode.fillColor = .white
    shapeNode.fillTexture = generateTexture()
    return shapeNode
}

let asteroid = generateAsteroid()
