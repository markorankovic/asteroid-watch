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
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
                
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        scnView.addGestureRecognizer(tapGesture)
        scnView.addGestureRecognizer(panGesture)
    }
    
    var pointsToScrollThrough: [SCNVector3] {
        let asteroids = scene.rootNode.childNodes.filter({ $0.name == "asteroid" })
        return asteroids.map {
            .init($0.position.x, $0.position.y, $0.position.z + $0.boundingSphere.radius * 10)
        }
    }
    
    func initAsteroids() {
        var prevX: CGFloat = 0
        var prevDiameter: CGFloat = 0
        let sizes = (1...10).map({ _ in Int.random(in: 1...30) / 2 }).sorted()
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
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
    }
    
    @objc
    func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
        let asteroids = scene.rootNode.childNodes.filter({ $0.name == "asteroid" })
        let velocity = gestureRecognize.velocity(in: view)
        let dx = velocity.x
        print("dx: \(dx)")
        let asteroidsBetween: (SCNNode?, SCNNode?) = {
            let lAsteroid = asteroids.filter{ $0.position.x < cameraNode.position.x }.first
            let rAsteroid = asteroids.filter{ $0.position.x > cameraNode.position.x }.first
            return (lAsteroid, rAsteroid)
        }()
        
        let baseDx: CGFloat = -5000
        
        var v: Float = 0
        
        var dz: Float = 0
        
        switch asteroidsBetween {
        case (nil, .some(let r)):
            if dx >= 0 {
                v = 0.1
                cameraNode.position.z = r.position.z + r.boundingSphere.radius * 10
            } else { v = -0.1 }
        case (.some(let l), nil):
            if dx <= 0 {
                v = 1
                cameraNode.position.z = l.position.z + l.boundingSphere.radius * 10
            } else { v = -1 }
        case (.some(let l), .some(let r)):
            let speed = Float((CGFloat(r.position.x - l.position.x) / baseDx) * dx)
            v = dx > 0 ? abs(speed) : -abs(speed)
            
            let lPosZ = l.position.z + l.boundingSphere.radius * 10
            let rPosZ = r.position.z + r.boundingSphere.radius * 10

            let speedZ = Float((CGFloat(rPosZ - lPosZ) / baseDx) * dx)
            dz = speedZ > 0 ? abs(speedZ) : -abs(speedZ)
        case (.none, .none): v = 0
        }
        
        print("v: \(v)")
        cameraNode.position.x += v
        cameraNode.position.z -= dz
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
