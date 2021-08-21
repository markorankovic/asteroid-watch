import SceneKit
import AsteroidWatchAPI

class SpeedComparisonScene: SCNScene {
    
    let realEarthSizeMeters = 12742000
    
    var cameraNode: SCNNode?
    var earth: SCNNode?
    
    var asteroids: [Asteroid] = []
    
//    init(asteroids: [Asteroid]) {
//        super.init()
//        let scene = SCNScene(named: "SizeComparison2.scn")!
//        self.background.contents = scene.background.contents
//        self.asteroids = asteroids.isEmpty ? self.asteroids : asteroids
//        initialize()
//    }
        
    func initialize() {
//        let camera = SCNCamera()
//        camera.zFar = 10000
//        camera.zNear = 0.001
//        cameraNode.camera = camera
//        cameraNode?.position.z = 10
        
//        earthNode.boundingBox = (min: SCNVector3(-0.5, -0.5, -0.5), max: SCNVector3(0.5, 0.5, 0.5))
//        print("earthNode.boundingBox: \(earthNode.boundingBox)")
//        earthNode.scale = .init(0.001, 0.001, 0.001)
//        rootNode.addChildNode(earthNode)
//        rootNode.addChildNode(cameraNode!)
        //addChildren(asteroids)
        
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor.white
//        rootNode.addChildNode(ambientLightNode)
    }
    
}
