import SpriteKit

public class LoadingScene: SKScene {
    
    public override func didMove(to view: SKView) {
        backgroundColor = .black
        for star in stars(count: Int((size.width * size.height)) / 2) {
            addChild(star)
        }
    }
    
    func stars(count: Int) -> [SKNode] {
        return (1...count).map { _ in
            let minLength = min(size.width, size.height)
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 1...minLength / 10))
            star.position = .init(
                x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height)
            )
            return star
        }
    }
    
}
