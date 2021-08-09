import SpriteKit
import PlaygroundSupport


let view = SKView(frame: .init(origin: .zero, size: .init(width: 500, height: 500)))

class Ball: SKShapeNode { }

extension SKShapeNode {
    public var radius: CGFloat {
        max(frame.width, frame.height) / 2
    }
}

extension Array where Element == Ball {
    internal func separated() -> [Ball] {
        let balls = self
        var prevRadius: CGFloat = 0
        var prevXOffset: CGFloat = 0
        for ball in balls {
            ball.position.x += ball.radius + prevRadius + prevXOffset
            prevRadius = ball.radius
            prevXOffset = ball.position.x
        }
        return balls
    }
}

extension Array {
    static func +(lhs: Array, rhs: Element) -> Array {
        var array = lhs
        array.append(rhs)
        return array
    }
}

class GameScene: SKScene {
    
    let nContenders = 1
    
    var balls: [Ball] = []
    
    let earth = SKShapeNode(circleOfRadius: 50)
    
    override func didMove(to view: SKView) {
        anchorPoint = .init(x: 0.5, y: 0.5)

        backgroundColor = .yellow
        
        balls = (1...nContenders).map { _ in
            let ball = Ball(circleOfRadius: .random(in: 5...20))
            ball.strokeColor = .black
            ball.fillColor = .red
            return ball
        }.sorted(by: { $0.radius < $1.radius }).separated()
                
        addChildren(balls + earth)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var prevRad: CGFloat = 0
        for ball in balls {
            var t = CGAffineTransform.identity.scaledBy(x: 1, y: -1)
            let path = CGPath(
                ellipseIn: .init(
                    origin: .init(x: -ball.radius, y: -ball.radius),
                    size: .init(
                        width: 100,
                        height: 100
                    )
                ),
                transform: &t
            )
            
            ball.run(
                SKAction.repeatForever(
                    SKAction.follow(
                        path,
                        asOffset: false,
                        orientToPath: true,
                        speed: 100
                    )
                )
            )
            prevRad += ball.radius
        }
    }
}

let scene = GameScene(size: view.frame.size)

view.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = view
