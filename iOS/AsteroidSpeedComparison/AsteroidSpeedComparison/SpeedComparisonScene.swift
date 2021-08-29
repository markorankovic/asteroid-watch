import SceneKit
import AsteroidWatchAPI
import GameplayKit

class AsteroidNode: SCNNode {
    
    public func run(speed: CGFloat, earthPos: SCNVector3) {
        runAction(.repeatForever(.rotate(
                                    by: speed,
                                    around: earthPos,
                                    duration: 60 * 1000)))
    }
    
}

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
        
        sphere.radius = sphere.radius * sphere.radius / CGFloat(sphere.boundingBox.max.y - sphere.boundingBox.min.y)
                
        sphere.boundingBox = box

        return sphere
    }
    
    func asteroidToAsteroidNode(_ asteroid: Asteroid) -> AsteroidNode {
        let asteroidNode = AsteroidNode()
        asteroidNode.geometry = initAsteroidShape()
        return asteroidNode
    }
    
    func startScene() {
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
            
}
