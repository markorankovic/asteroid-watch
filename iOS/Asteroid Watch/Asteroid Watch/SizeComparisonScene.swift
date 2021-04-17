import SceneKit
import AsteroidWatchAPI
import GameplayKit
import SwiftUI

class SizeComparisonScene: SCNScene {
    
    var cameraNode = SCNNode()
    
    var asteroids: [Asteroid] = []
    
    var comparables: [SizeComparable] = []
    
    var references: [SizeComparable] = [
        SizeComparable(
            diameter: 830,
            node: {
                let node = SCNScene(
                named: "models.scnassets/burj_khalifa.obj"
                )!.rootNode
                node.name = "comparable"
                return node
            }(),
            name: "Burj Khalifa"
        )
    ]
    
    init(asteroids: [Asteroid]) {
        super.init()
        let scene = SCNScene(named: "SizeComparison.scn")!
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
        
        didGetAsteroids()
    }
    
    var bag: [AnyCancellable] = []
    
    func didGetAsteroids() {
        initComparables()
        
        let comparables = rootNode.childNodes.filter({ $0.name == "comparable" })
        
        guard let firstComparable = comparables.first, let lastComparable = comparables.last, firstComparable != lastComparable else {
            return
        }
        
        let length = CGFloat(lastComparable.position.x - firstComparable.position.x)
        
        initLine(length: length)
        
        cameraNode.position = firstComparable.position
        cameraNode.position.z += firstComparable.boundingSphere.radius * 6
        
        cameraNode.constraints = [
            SCNTransformConstraint.positionConstraint(
                inWorldSpace: false,
                with: { (node, position) -> SCNVector3 in
                    var constrainedPosition = position
                    if position.x < firstComparable.position.x {
                        constrainedPosition.x = firstComparable.position.x
                        node.position.x = firstComparable.position.x
                    } else if position.x > lastComparable.position.x {
                        constrainedPosition.x = lastComparable.position.x
                        node.position.x = lastComparable.position.x
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
    
    func initComparablePos(_ comparable: SCNNode, _ prevX: CGFloat, _ prevDiameter: CGFloat) {
        comparable.position.x = Float(5 * (comparable.width / 2)) / 2 + Float(prevDiameter) + Float(prevX)
        if let _ = comparable.geometry?.firstMaterial?.displacement.intensity {
            comparable.position.y = comparable.boundingBox.max.y - comparable.boundingBox.min.y
        } else {
            comparable.position.y = Float(comparable.height / 2)
        }
        print("Pos X: \(comparable.position.x)")
        print("Pos Y: \(comparable.position.y)")
    }
    
    func initAsteroidShape(_ r: CGFloat) -> SCNGeometry {
        let sphere = SCNSphere(radius: r)
        sphere.isGeodesic = true
        
        let source = GKPerlinNoiseSource()
        source.seed = Int32.random(in: 1...100)
        let noise = GKNoiseMap(
            GKNoise(source), size: simd_double2(5, 5), origin: simd_double2(0, 0), sampleCount: vector_int2(100, 100), seamless: true
        )
        
        let tex = SKTexture(noiseMap: noise)
        
        sphere.firstMaterial!.displacement.contents = tex
        sphere.firstMaterial!.displacement.intensity = r
        sphere.firstMaterial!.diffuse.contents = UIImage(named: "asteroid_tex\(Int.random(in: 1...10))")
        
        return sphere
    }
    
    func initDetails(c: SizeComparable, r: CGFloat, diameter: CGFloat) {
        let str = "\(c.name)"
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
                let text = SCNText(string: "\(Int(c.diameter))M", extrusionDepth: 0)
                text.font = font
                return text
            }()
        )
        diameterDetail.pivot = SCNMatrix4MakeTranslation(
            (diameterDetail.boundingBox.max.x - diameterDetail.boundingBox.min.x) / 2,
            (diameterDetail.boundingBox.min.y),
            (diameterDetail.boundingBox.max.z - diameterDetail.boundingBox.min.z) / 2
        )
                    
        diameterDetail.position = c.node.position
        diameterDetail.position.y = Float(-r * 0.8 - CGFloat(nameDetail.geometry!.boundingBox.max.y - nameDetail.geometry!.boundingBox.min.y))

        nameDetail.position = c.node.position
        nameDetail.position.y = Float(-r * 0.8)
        
        rootNode.addChildNode(nameDetail)
        rootNode.addChildNode(diameterDetail)
    }
    
    func addAsteroidsToComparables() {
        let sortedAsteroids = asteroids.sorted(
            by: {
                $0.diameter < $1.diameter
            }
        )
        
        guard let firstAsteroid = sortedAsteroids.first else {
            return
        }
                
        comparables.append(contentsOf: sortedAsteroids.map {
            let diameter = CGFloat($0.diameter / firstAsteroid.diameter)
            let comparable = SizeComparable(
                diameter: $0.diameter,
                node: SCNNode(geometry: initAsteroidShape(diameter / 2)),
                name: $0.name
            )
            comparable.node.name = "comparable"
            return comparable
        })
    }
        
    func addReferencesToComparables() {
        let smallestAsteroid = asteroids.min(by: { $0.diameter < $1.diameter })!
        for reference in references {
            reference.node.scale = .init(
                reference.diameter / smallestAsteroid.diameter,
                reference.diameter / smallestAsteroid.diameter,
                reference.diameter / smallestAsteroid.diameter
            )
        }

        let maxNReferences = min(asteroids.count / 5, references.count)
        var i = 1
        while i <= maxNReferences {
            let reference = references.randomElement()!
            if !comparables.contains(where: { $0 == reference }) {
                comparables.append(reference)
            }
            i += 1
        }
    }
    
    func initComparables() {
        addAsteroidsToComparables()
        addReferencesToComparables()
                
        var prevX: CGFloat = 0
        var prevDiameter: CGFloat = 0
        let comparablesSorted = comparables.sorted(
            by: {
                $0.diameter < $1.diameter
            }
        )
        for c in comparablesSorted {
            print("diameter: \(c.diameter)")
            
            var r: CGFloat = 0
            
            if let _ = c.node.geometry?.firstMaterial?.displacement.intensity {
                r = CGFloat(c.node.boundingBox.max.y - c.node.boundingBox.min.y) / 2
            } else {
                r = CGFloat(Float(c.node.height / 2))
            }
            
            let diameter = r * 2
            
            initComparablePos(c.node, prevX, prevDiameter)
                        
            initDetails(c: c, r: r, diameter: diameter)
            
            rootNode.addChildNode(c.node)
            
            prevDiameter = CGFloat(diameter)
            prevX = CGFloat(c.node.position.x)
            c.node.runAction(
                SCNAction.repeatForever(
                    .rotateBy(x: 0, y: 6.28, z: 0, duration: 7)
                )
            )
        }
    }
    
    func handleTap(_ gestureRecognize: UITapGestureRecognizer) { }
    
    func handlePan(_ speed: CGFloat) {
        let comparables = rootNode.childNodes.filter({ $0.name == "comparable" })
        let dx = speed
        print("dx: \(dx)")
        let asteroidsBetween: (SCNNode?, SCNNode?) = {
            let lAsteroid = comparables.filter{
                $0.position.x < cameraNode.position.x
            }.sorted(by:
                { $0.position.x >= $1.position.x }
            ).first
            
            let rAsteroid = comparables.filter{
                $0.position.x > cameraNode.position.x
            }.sorted(by:
                { $0.position.x <= $1.position.x}
            ).first
            
            return (lAsteroid, rAsteroid)
        }()
        
        let baseDx: CGFloat = 20000
        
        switch asteroidsBetween {
        
        case (nil, .some(_)):
            let r = comparables[0]
            var rPos = r.position
            rPos.z = r.position.z + (Float(r.depth) / 2) * 6
            var lPos = r.position
            lPos.x = r.position.x - 0.001
            lPos.z = r.position.z + (Float(r.depth) / 2) * 6
            
            lerp(
                p1: lPos,
                p2: rPos,
                baseDx: baseDx,
                dx: dx
            )

        case (.some(_), nil):
            let l = comparables[comparables.count - 1]
            var lPos = l.position
            lPos.z = l.position.z + (Float(l.depth) / 2) * 6
            var rPos = cameraNode.position
            rPos.x = cameraNode.position.x + 1
            rPos.z = l.position.z + (Float(l.depth) / 2) * 6
            
            lerp(
                p1: lPos,
                p2: rPos,
                baseDx: baseDx,
                dx: dx
            )

        case (.some(let l), .some(let r)):
            var lPos = l.position
            lPos.z = l.position.z + (Float(l.depth) / 2) * 6
            var rPos = r.position
            rPos.z = r.position.z + (Float(r.depth) / 2) * 6
            
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
