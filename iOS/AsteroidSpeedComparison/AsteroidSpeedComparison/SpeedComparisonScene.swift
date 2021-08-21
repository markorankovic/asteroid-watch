import SceneKit
import AsteroidWatchAPI

class SpeedComparisonScene: SCNScene {
    
    let cameraNode = SCNNode()
    
    let earthNode = SCNScene(named: "models.scnassets/earth.usdz")!.rootNode
    
    var asteroids: [Asteroid] = [
        Asteroid(
            id: "Asteroid 1",
            name: "Asteroid 1",
            diameter: 1,
            missDistance: 0,
            velocity: 10,
            date: nil,
            isHazardous: false
        ),
        Asteroid(
            id: "Asteroid 2",
            name: "Asteroid 2",
            diameter: 1,
            missDistance: 0,
            velocity: 100,
            date: nil,
            isHazardous: false
        ),
        Asteroid(
            id: "Asteroid 3",
            name: "Asteroid 3",
            diameter: 1,
            missDistance: 0,
            velocity: 1000,
            date: nil,
            isHazardous: false
        )
    ]
    
    init(asteroids: [Asteroid]) {
        super.init()
        let scene = SCNScene(named: "SizeComparison.scn")!
        self.background.contents = scene.background.contents
        self.asteroids = asteroids.isEmpty ? self.asteroids : asteroids
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        let camera = SCNCamera()
//        camera.zFar = 10000
//        camera.zNear = 0.001
        cameraNode.camera = camera
        cameraNode.position.z = 10
        
//        earthNode.boundingBox = (min: SCNVector3(-0.5, -0.5, -0.5), max: SCNVector3(0.5, 0.5, 0.5))
//        print("earthNode.boundingBox: \(earthNode.boundingBox)")
        //earthNode.scale = .init(0.001, 0.001, 0.001)
        rootNode.addChildNode(earthNode)
        rootNode.addChildNode(cameraNode)
        //addChildren(asteroids)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.white
        rootNode.addChildNode(ambientLightNode)
    }
    
}
