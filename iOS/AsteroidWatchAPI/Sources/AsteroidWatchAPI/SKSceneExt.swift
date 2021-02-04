import SpriteKit

public extension SKScene {
    
    func addChildren(_ children: [SKNode]) {
        for child in children {
            addChild(child)
        }
    }
    
}
