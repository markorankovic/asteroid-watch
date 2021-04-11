import SceneKit
import AsteroidWatchAPI
import GameplayKit
import SwiftUI

class SizeComparisonScene3D: SCNScene {
        
    var cameraNode = SCNNode()
    
    var asteroids: [Asteroid] = []
        
    init(asteroids: [Asteroid]) {
        super.init()
        let scene = SCNScene(named: "SizeComparison3D.scn")!
        self.background.contents = scene.background.contents
        self.asteroids = asteroids
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        print("View loaded")
        let camera = SCNCamera()
        camera.zFar = 10000
        camera.zNear = 0.01
        cameraNode.camera = camera
        rootNode.addChildNode(cameraNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        rootNode.addChildNode(ambientLightNode)
        
        self.didGetAsteroids(asteroids: asteroids)
    }
    
    var bag: [AnyCancellable] = []
    
    func didGetAsteroids(asteroids: [Asteroid]) {
        initAsteroids(asteroids: asteroids)
        
        let asteroids = rootNode.childNodes.filter({ $0.name == "asteroid" })
        
        guard let firstAsteroid = asteroids.first, let lastAsteroid = asteroids.last, firstAsteroid != lastAsteroid else {
            return
        }
        
        let length = CGFloat(lastAsteroid.position.x - firstAsteroid.position.x)
        
        initLine(length: length)
        
        cameraNode.position = firstAsteroid.position
        cameraNode.position.z += firstAsteroid.boundingSphere.radius * 6
        
        cameraNode.constraints = [
            SCNTransformConstraint.positionConstraint(
                inWorldSpace: false,
                with: { (node, position) -> SCNVector3 in
                    var constrainedPosition = position
                    if position.x < firstAsteroid.position.x {
                        constrainedPosition.x = firstAsteroid.position.x
                        node.position.x = firstAsteroid.position.x
                    } else if position.x > lastAsteroid.position.x {
                        constrainedPosition.x = lastAsteroid.position.x
                        node.position.x = lastAsteroid.position.x
                    }
                    return constrainedPosition
                }
            )
        ]
    }

    func initLine(length: CGFloat) {
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor.white
        mat.transparency = 0.05
        let box = SCNBox(
            width: length * 2.5,
            height: 2,
            length: 0.1,
            chamferRadius: 0
        )
        box.firstMaterial = mat
        let node = SCNNode(geometry: box)
        node.position.x = Float(length/2)
        node.position.y = 1
        rootNode.addChildNode(node)
    }
    
//    func initSizeComparables(comparables: [SizeComparable]) {
//
//    }
    
    func initAsteroids(asteroids: [Asteroid]) {
        var prevX: CGFloat = 0
        var prevDiameter: CGFloat = 0
        guard let firstAsteroid = asteroids.sorted(by: { $0.diameter < $1.diameter }).first else { return }
        for a in asteroids.sorted(by: { $0.diameter < $1.diameter }) {
            print("diameter: \(a.diameter)")
            let r = CGFloat(a.diameter / firstAsteroid.diameter)/2
            
            let diameter = CGFloat(r * 2)
            
            let sphere = SCNSphere(radius: r)
            sphere.isGeodesic = true
            
            let source = GKPerlinNoiseSource()
            source.seed = Int32.random(in: 1...100)
            let noise = GKNoiseMap(
                GKNoise(source), size: simd_double2(5, 5), origin: simd_double2(0, 0), sampleCount: vector_int2(100, 100), seamless: true
            )
 
            let tex = SKTexture(noiseMap: noise)
            
            sphere.firstMaterial!.displacement.contents = tex
            sphere.firstMaterial!.displacement.intensity = 1
            sphere.firstMaterial!.diffuse.contents = UIImage(named: "asteroid_tex\(Int.random(in: 1...10))")
            
            let asteroid = SCNNode(geometry: sphere)
            asteroid.name = "asteroid"
            asteroid.position.x += Float(5 * r) / 2 + Float(prevDiameter) + Float(prevX)
            asteroid.position.y += Float(r)
            
            let str = "\(a.name)"
            let fontsize = diameter / 10
            let font = UIFont(name: "COPPERPLATE", size: fontsize)
            let nameDetail = SCNNode(
                geometry: {
                    let text = SCNText(string: str, extrusionDepth: 0)
                    text.font = font
                    return text
                }()
            )
            nameDetail.pivot = SCNMatrix4MakeTranslation(
                (nameDetail.boundingBox.max.x - nameDetail.boundingBox.min.x) / 2,
                (nameDetail.boundingBox.min.y),
                (nameDetail.boundingBox.max.z - nameDetail.boundingBox.min.z) / 2
            )
            let diameterDetail = SCNNode(
                geometry: {
                    let text = SCNText(string: "\(Int(a.diameter))M", extrusionDepth: 0)
                    text.font = font
                    return text
                }()
            )
            diameterDetail.pivot = SCNMatrix4MakeTranslation(
                (diameterDetail.boundingBox.max.x - diameterDetail.boundingBox.min.x) / 2,
                (diameterDetail.boundingBox.min.y),
                (diameterDetail.boundingBox.max.z - diameterDetail.boundingBox.min.z) / 2
            )
            
            rootNode.addChildNode(asteroid)
            
            diameterDetail.position = asteroid.position
            diameterDetail.position.y = Float(-r * 0.8 - CGFloat(nameDetail.geometry!.boundingBox.max.y - nameDetail.geometry!.boundingBox.min.y))

            nameDetail.position = asteroid.position
            nameDetail.position.y = Float(-r * 0.8)
            
            rootNode.addChildNode(nameDetail)
            rootNode.addChildNode(diameterDetail)
            
            prevDiameter = CGFloat(diameter)
            prevX = CGFloat(asteroid.position.x)
            asteroid.runAction(
                SCNAction.repeatForever(
                    .rotateBy(x: 0, y: 6.28, z: 0, duration: 7)
                )
            )
        }
    }
    
    func handleTap(_ gestureRecognize: UITapGestureRecognizer) { }
    
    func handlePan(_ speed: CGFloat) {
        let asteroids = rootNode.childNodes.filter({ $0.name == "asteroid" })
        let dx = speed
        print("dx: \(dx)")
        let asteroidsBetween: (SCNNode?, SCNNode?) = {
            let lAsteroid = asteroids.filter{
                $0.position.x < cameraNode.position.x
            }.sorted(by:
                { $0.position.x >= $1.position.x }
            ).first
            
            let rAsteroid = asteroids.filter{
                $0.position.x > cameraNode.position.x
            }.sorted(by:
                { $0.position.x <= $1.position.x}
            ).first
            
            return (lAsteroid, rAsteroid)
        }()
        
        let baseDx: CGFloat = 20000
        
        switch asteroidsBetween {
        
        case (nil, .some(_)):
            let r = asteroids[0]
            var rPos = r.position
            rPos.z = r.position.z + r.boundingSphere.radius * 6
            var lPos = r.position
            lPos.x = r.position.x - 0.001
            lPos.z = r.position.z + r.boundingSphere.radius * 6
            
            lerp(
                p1: lPos,
                p2: rPos,
                baseDx: baseDx,
                dx: dx
            )

        case (.some(_), nil):
            let l = asteroids[asteroids.count - 1]
            var lPos = l.position
            lPos.z = l.position.z + l.boundingSphere.radius * 6
            var rPos = cameraNode.position
            rPos.x = cameraNode.position.x + 1
            rPos.z = l.position.z + l.boundingSphere.radius * 6
            
            lerp(
                p1: lPos,
                p2: rPos,
                baseDx: baseDx,
                dx: dx
            )

        case (.some(let l), .some(let r)):
            var lPos = l.position
            lPos.z = l.position.z + l.boundingSphere.radius * 6
            var rPos = r.position
            rPos.z = r.position.z + r.boundingSphere.radius * 6
            
            lerp(
                p1: lPos,
                p2: rPos,
                baseDx: baseDx,
                dx: dx
            )
            
        case (.none, .none): break
            
        }
    }
    
    var prevLerpZ: Float = 0
    
    func lerp(p1: SCNVector3, p2: SCNVector3, baseDx: CGFloat, dx: CGFloat) {
        let lPosZ = p1.z
        let rPosZ = p2.z
                    
        let lPosX = p1.x
        let rPosX = p2.x
        let lerpX = Float(dx) * (rPosX - lPosX) / Float(baseDx)
        let currentX = cameraNode.position.x
        
        let lPosY = p1.y
        let rPosY = p2.y
        
        let lerpZ = lPosZ * (1 - (currentX - lPosX) / (rPosX - lPosX)) + rPosZ * (currentX - lPosX) / (rPosX - lPosX)
                
        prevLerpZ = lerpZ
        
        print("lerpZ: \(lerpZ)")
        
        cameraNode.position.x -= lerpX
        cameraNode.position.z = lerpZ
        cameraNode.position.y = lPosY * (1 - (currentX - lPosX) / (rPosX - lPosX)) + rPosY * (currentX - lPosX) / (rPosX - lPosX)
    }

}
