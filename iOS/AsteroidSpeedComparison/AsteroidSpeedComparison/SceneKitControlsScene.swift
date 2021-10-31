import SpriteKit
import SceneKit

class SceneKitControlsScene: SKScene {
    
    let backButton = SKLabelNode(text: "Back")
    let nextButton = SKLabelNode(text: "Next")
    
    var scnScene: ControllableScene?
    
    public override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        anchorPoint = .init(x: 0, y: 0.5)
        addChild(backButton)
        addChild(nextButton)
        backButton.position.x = backButton.frame.width / 2
        nextButton.position.x = 100
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodeTapped = nodes(at: touches.first!.location(in: self)).first!
        if nodeTapped == backButton {
            scnScene?.panToPreviousNode()
        } else if nodeTapped == next {
            scnScene?.panToNextNode()
        }
    }
    
}
