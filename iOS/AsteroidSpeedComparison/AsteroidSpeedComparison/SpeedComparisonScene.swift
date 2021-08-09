import SceneKit

class SpeedComparisonScene: SCNScene {
    
    let cameraNode = SCNNode()
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        let camera = SCNCamera()
        cameraNode.camera = camera
        rootNode.addChildNode(cameraNode)
    }
    
}
