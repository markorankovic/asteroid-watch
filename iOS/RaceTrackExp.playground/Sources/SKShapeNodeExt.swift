import SpriteKit

extension SKShapeNode {
    public var radius: CGFloat {
        max(frame.width, frame.height) / 2
    }
}

extension CGPoint {
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(
            x: rhs.x - lhs.x,
            y: rhs.y - lhs.y
        )
    }
}

extension SKScene {
    public func addChildren(_ nodes: [SKNode]) {
        for node in nodes {
            addChild(node)
        }
    }
}
