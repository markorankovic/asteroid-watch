import SceneKit
import AsteroidWatchAPI
import GameplayKit
<<<<<<< Updated upstream

class AsteroidNode: SCNNode {
    
    public func run(speed: CGFloat, earthPos: SCNVector3) {
        runAction(.repeatForever(.rotate(
                                    by: speed,
                                    around: earthPos,
                                    duration: 60 * 1000)))
=======
import SwiftUI

let earthCircumference: CGFloat = 40075000

class AsteroidNode: SCNNode {
    
    public func run(speed speedInMetersPerHour: CGFloat, scene: SpeedComparisonScene, earthNode: SCNNode) {
        let orbitRadius = position.x
        
        let durationToGoAround = (earthCircumference / speedInMetersPerHour) * 3600
        var currentAngle: Float = 0
        runAction(.repeatForever(.sequence([.wait(duration: 0.01), .run({ _ in
            let angularIncrease: Float = Float(2.0 * .pi) / (Float(durationToGoAround) * 100) * Float(scene.scale)
            print("angularIncrease: \(angularIncrease)")
            self.position.x = orbitRadius * cos(currentAngle + angularIncrease)
            self.position.z = orbitRadius * sin(currentAngle + angularIncrease)
            currentAngle += angularIncrease
        })])))
>>>>>>> Stashed changes
    }
    
}

<<<<<<< Updated upstream
class SpeedComparisonScene: SCNScene {
        
    let rng = GKARC4RandomSource(seed: Data([1, 2, 3]))
    
    var cameraNode: SCNNode? {
        return rootNode.childNode(withName: "camera", recursively: false)
    }
    
    var earth: SCNNode? {
        return rootNode.childNode(withName: "earth", recursively: false)
    }
    
    var asteroids: [Asteroid] = []
    
    func initAsteroidShape() -> SCNGeometry {
        let r: CGFloat = 1
        let sphere = SCNSphere(radius: r)
        sphere.isGeodesic = true
        
=======
public class SpeedComparisonScene: ControllableScene {
    
    public var scale = 1
    
    let rng = GKARC4RandomSource(seed: Data([1, 2, 3]))
    
    let cameraNode = { () -> SCNNode in
        let camera = SCNCamera()
        camera.zNear = 1
        camera.zFar = 10000
        let node = SCNNode()
        node.camera = camera
        node.position.z = -200
        node.position.y = 50
        node.position.x = 1100
        node.rotation = .init(0, 0.1, 0, 1)
        return node
    }()
    
    let earth = { () -> SCNNode in
        return SCNScene(
            named: "models.scnassets/earth.scn"
        )!.rootNode.childNode(
            withName: "earth",
            recursively: false
        )!
//        return SCNScene(
//            named: "models.scnassets/earth.scn"
//        )!.rootNode
    }()
    
    var asteroids: [Asteroid] = []
    
    func initAsteroidShape(asteroid: Asteroid) -> SCNGeometry {
        print("Original asteroid diameter: \(asteroid.diameter)")
        let scaledAsteroidDiameter = (earth.boundingBox.max.x - earth.boundingBox.min.x) / 3
        let r = CGFloat(scaledAsteroidDiameter / 2)
        let sphere = SCNSphere(radius: r)
        sphere.isGeodesic = true
        
        print("scaledAsteroidDiameter: \(scaledAsteroidDiameter)")
        
>>>>>>> Stashed changes
        let source = GKPerlinNoiseSource()
        source.seed = Int32.random(in: 1...100)
        let noise = GKNoiseMap(
            GKNoise(source), size: simd_double2(5, 5), origin: simd_double2(0, 0), sampleCount: vector_int2(100, 100), seamless: true
        )
        
        let tex = SKTexture(noiseMap: noise)
        
        sphere.firstMaterial!.displacement.contents = tex
        sphere.firstMaterial!.displacement.intensity = (r) / 2
        sphere.firstMaterial!.diffuse.contents = UIImage(named: "asteroid_tex\(Int.random(in: 1...10))")
                
        let box = sphere.boundingBox
<<<<<<< Updated upstream
        
        sphere.radius = sphere.radius * sphere.radius / CGFloat(sphere.boundingBox.max.y - sphere.boundingBox.min.y)
                
=======

        sphere.radius = sphere.radius * sphere.radius / CGFloat(box.max.y - box.min.y)

>>>>>>> Stashed changes
        sphere.boundingBox = box

        return sphere
    }
    
    func asteroidToAsteroidNode(_ asteroid: Asteroid) -> AsteroidNode {
        let asteroidNode = AsteroidNode()
<<<<<<< Updated upstream
        asteroidNode.geometry = initAsteroidShape()
=======
        asteroidNode.name = asteroid.name
        asteroidNode.geometry = initAsteroidShape(asteroid: asteroid)
>>>>>>> Stashed changes
        return asteroidNode
    }
    
    func startScene() {
<<<<<<< Updated upstream
        for (i, asteroid) in asteroids.enumerated() {
            let rng = GKARC4RandomSource(seed: asteroid.name.data(using: .utf8)!)
            rng.nextUniform()
            let asteroidNode = asteroidToAsteroidNode(asteroid)
            let angle = 2 * .pi * CGFloat(i) / CGFloat(asteroids.count)
            let radius: CGFloat = 10
            asteroidNode.position = .init(
                cos(angle) * radius,
                0,
                sin(angle) * radius
            )
            
            asteroidNode.run(speed: CGFloat(asteroid.velocity), earthPos: earth!.position)
            rootNode.addChildNode(asteroidNode)
            print(asteroidNode.position)
        }
    }
            
=======
        addChildren([earth, cameraNode])
        self.background.contents = UIColor.black
        let earthRadius = earth.boundingSphere.radius
        print("Earth radius: \(earthRadius)")
        var asteroidNodes: [AsteroidNode] = []
        for (i, asteroid) in asteroids.enumerated() {

            let asteroidNode = asteroidToAsteroidNode(asteroid)
            
            let asteroidRadius = asteroidNode.boundingSphere.radius
                                    
            let padding = asteroidRadius
            
            let awayFromEarth = asteroidRadius + (
                (i - 1 > -1) ?
                    asteroidNodes[i - 1].boundingSphere.radius +
                    abs(asteroidNodes[i - 1].position.x)
                    : earthRadius
            ) + padding * 5
            
            asteroidNode.position.x = -awayFromEarth
            
            asteroidNodes.append(asteroidNode)
                        
            rootNode.addChildNode(asteroidNode)
            
            asteroidNode.run(
                speed: CGFloat(asteroid.velocity),
                scene: self,
                earthNode: earth
            )
            
            let orbitGeo = SCNTorus(
                ringRadius: abs(CGFloat(asteroidNode.position.x)),
                pipeRadius: 1
            )
            orbitGeo.pipeSegmentCount = 10
            let orbit = SCNNode(geometry: orbitGeo)
            
            rootNode.addChildNode(orbit)
            
            if i + 1 == asteroids.count {
                let finishLineGeo = SCNBox(
                    width: abs(CGFloat(asteroidNode.position.x)) - CGFloat(earthRadius),
                    height: 1,
                    length: 5,
                    chamferRadius: 0
                )
                                                
                finishLineGeo.firstMaterial?.diffuse.contents = CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
                
                let finishLine = SCNNode(geometry: finishLineGeo)
                
                finishLine.position.x -= finishLine.boundingSphere.radius + earthRadius
                
                rootNode.addChildNode(finishLine)
            }
        }
    }

>>>>>>> Stashed changes
}
