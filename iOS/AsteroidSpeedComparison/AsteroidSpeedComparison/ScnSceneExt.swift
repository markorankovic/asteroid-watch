import SceneKit

public extension SCNScene {
    
    func addChildren(_ children: [SCNNode]) {
        for child in children {
            rootNode.addChildNode(child)
        }
    }
    
}
