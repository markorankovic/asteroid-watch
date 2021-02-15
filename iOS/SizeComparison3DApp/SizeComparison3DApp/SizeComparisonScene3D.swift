import UIKit
import QuartzCore
import SceneKit
import ARKit

class SizeComparisonScene3D: UIViewController {
    
    let scene = SCNScene(named: "art.scnassets/asteroid3.scn")!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraNode = SCNNode()
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
        
        //initAsteroids()
    }
    
    func initAsteroids() {
        let box = SCNBox()
        box.subdivisionLevel = 3
        let asteroid = SCNNode(geometry: box)
        scene.rootNode.addChildNode(asteroid)
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
