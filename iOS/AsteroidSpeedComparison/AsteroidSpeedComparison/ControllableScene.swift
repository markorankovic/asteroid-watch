import SceneKit

public class ControllableScene: SCNScene {
    
    var currentNodeIndex: Int = 0
    
    func panToPreviousNode() {
        panToNextNode(next: false)
    }
    
    func panToNextNode() {
        panToNextNode(next: true)
    }
    
    func panToNextNode(next: Bool) {
        print("panToNextNode")
        if rootNode.childNodes.count < 0 {
            return
        }
        currentNodeIndex += next ? 1 : -1
        if currentNodeIndex < 0 {
            currentNodeIndex = rootNode.childNodes.count - 1
        }
        else
        if currentNodeIndex > rootNode.childNodes.count - 1 {
            currentNodeIndex = 0
        }
        panToNode(
            rootNode.childNodes[
                currentNodeIndex
            ]
        )
    }
    
    func panToNode(_ node: SCNNode) {
        let camera = rootNode.childNodes.filter(
            {
                $0.camera != nil
            }
        )
        .first
        var targetPosition = node.position
        targetPosition.z = node.position.z + node.boundingSphere.radius * 2
        camera!.runAction(.sequence([
            .move(
                to: targetPosition,
                duration: 1
            ),
            .run({ _ in
                //camera!.look(at: node.position)
                print(1)
            })
        ]))
        print("Camera panned to \(node.name ?? "nil")")
    }
}
