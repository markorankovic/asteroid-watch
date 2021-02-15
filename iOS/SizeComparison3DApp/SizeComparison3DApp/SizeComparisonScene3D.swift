import UIKit
import QuartzCore
import SceneKit
import ARKit

class SizeComparisonScene3D: UIViewController {
    
    let scene = SCNScene()
    
    let cameraNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraNode.camera = SCNCamera()
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
        scnView.allowsCameraControl = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
                
        initAsteroids()
        initCameraSequence()
    }
    
    func initCameraSequence() {
        let asteroids = scene.rootNode.childNodes.filter{ $0.name == "asteroid" }
        let sequence = SCNAction.sequence(asteroids.map {
            var pos = $0.position
            pos.z = ($0.geometry!.boundingSphere.radius) * 10
            return SCNAction.sequence([
                SCNAction.move(
                    to: pos,
                    duration: 3
                ),
                SCNAction.wait(duration: 3)
            ])
        })
        cameraNode.runAction(sequence)
    }
    
    func initAsteroids() {
        var prevX: CGFloat = 0
        var prevDiameter: CGFloat = 0
        for i in 1...10 {
            let diameter = i
            
            let sphere = SCNSphere(radius: CGFloat(diameter) / 2)
            sphere.isGeodesic = true
            
            print(Bundle.main.bundleURL)
            sphere.firstMaterial!.displacement.contents = UIImage(named: "noise")
            sphere.firstMaterial!.diffuse.contents = UIImage(named: "asteroid")
            
            let asteroid = SCNNode(geometry: sphere)
            asteroid.name = "asteroid"
            asteroid.position.x += Float(3 * diameter) / 2 + Float(prevDiameter) + Float(prevX)
            asteroid.position.y += Float(diameter) / 2
            scene.rootNode.addChildNode(asteroid)
            prevDiameter = CGFloat(diameter)
            prevX = CGFloat(asteroid.position.x)
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
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
