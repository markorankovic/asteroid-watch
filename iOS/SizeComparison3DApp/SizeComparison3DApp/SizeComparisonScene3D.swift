import UIKit
import QuartzCore
import SceneKit
import ARKit

class SizeComparisonScene3D: UIViewController {
    
    let scene = SCNScene()
    
    var cameraNode = SCNNode()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = SCNCamera()
        camera.zFar = 1000
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
                
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
        
        initAsteroids()
        
        let asteroids = scene.rootNode.childNodes.filter({ $0.name == "asteroid" })
        
        let length = CGFloat(asteroids.last!.position.x - asteroids.first!.position.x)
        
        initLine(length: length)
        
        scene.background.contents = [
            UIImage(named: "row-1-col-1"),
            UIImage(named: "row-1-col-2"),
            UIImage(named: "row-1-col-3"),
            
            UIImage(named: "row-2-col-1"),
            UIImage(named: "row-2-col-2"),
            UIImage(named: "row-2-col-3"),
        ]
        
        guard let firstAsteroid = asteroids.first, let lastAsteroid = asteroids.last, firstAsteroid != lastAsteroid else {
            return
        }
        
        cameraNode.position = firstAsteroid.position
        cameraNode.position.z += firstAsteroid.boundingSphere.radius * 5
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        scnView.addGestureRecognizer(tapGesture)
        scnView.addGestureRecognizer(panGesture)
                
        print(asteroids.count)
    }
    
    func initLine(length: CGFloat) {
        let box = SCNBox(
            width: length * 2,
            height: 0.5,
            length: 0.5,
            chamferRadius: 0
        )
        let node = SCNNode(geometry: box)
        node.position.x = Float(length/2)
        scene.rootNode.addChildNode(node)
    }
    
    func initAsteroids() {
        var prevX: CGFloat = 0
        var prevDiameter: CGFloat = 0
        let sizes = (1...10)
        for r in sizes {
            let diameter: CGFloat = CGFloat(r * 2)
            
            let sphere = SCNSphere(radius: CGFloat(r))
            sphere.isGeodesic = true
            
            sphere.firstMaterial!.displacement.contents = UIImage(named: "noise")
            sphere.firstMaterial!.diffuse.contents = UIImage(named: "asteroid")
            
            let asteroid = SCNNode(geometry: sphere)
            asteroid.name = "asteroid"
            asteroid.position.x += Float(3 * r) / 2 + Float(prevDiameter) + Float(prevX)
            asteroid.position.y += Float(r)
            scene.rootNode.addChildNode(asteroid)
            prevDiameter = CGFloat(diameter)
            prevX = CGFloat(asteroid.position.x)
            asteroid.runAction(
                SCNAction.repeatForever(
                    .rotateBy(x: 0, y: 6.28, z: 0, duration: 7)
                )
            )
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UITapGestureRecognizer) { }
    
    @objc
    func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
        let asteroids = scene.rootNode.childNodes.filter({ $0.name == "asteroid" })
        let velocity = gestureRecognize.velocity(in: view)
        let dx = velocity.x
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
        
        let baseDx: CGFloat = -20000
                
        switch asteroidsBetween {
        
        case (nil, .some(_)):
            let r = asteroids[0]
            var rPos = r.position
            rPos.z = r.position.z + r.boundingSphere.radius * 5
            var lPos = r.position
            lPos.x = r.position.x - 0.001
            lPos.z = r.position.z + r.boundingSphere.radius * 5
            
            lerp(
                p1: lPos,
                p2: rPos,
                baseDx: baseDx,
                dx: dx
            )

        case (.some(_), nil):
            let l = asteroids[asteroids.count - 1]
            var lPos = l.position
            lPos.z = l.position.z + l.boundingSphere.radius * 5
            var rPos = cameraNode.position
            rPos.x = cameraNode.position.x + 0.001
            rPos.z = l.position.z + l.boundingSphere.radius * 5
            
            lerp(
                p1: lPos,
                p2: rPos,
                baseDx: baseDx,
                dx: dx
            )

        case (.some(let l), .some(let r)):
            var lPos = l.position
            lPos.z = l.position.z + l.boundingSphere.radius * 5
            var rPos = r.position
            rPos.z = r.position.z + r.boundingSphere.radius * 5
            
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

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
