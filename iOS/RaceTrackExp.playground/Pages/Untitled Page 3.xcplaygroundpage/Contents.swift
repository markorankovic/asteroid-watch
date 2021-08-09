import SpriteKit
import PlaygroundSupport

class TestScene: SKScene {
    
    let earth: SKShapeNode = {
        let ball = SKShapeNode(circleOfRadius: 50)
        ball.fillColor = .blue
        return ball
    }()
        
    let balls: [SKShapeNode] = (1...6).map {
        let ball = SKShapeNode(circleOfRadius: CGFloat($0 * 5))
        return ball
    }
    
    func centerEverything() {
        anchorPoint = .init(x: 0.5, y: 0.5)
    }
    
    func addTheStuff() {
        addChild(earth)
        addChildren(balls)
    }
    
    func scaleTheSceneToView() {
        scaleMode = .resizeFill
    }
    
    let spaceFactor: CGFloat = 1.0
    
    let clockwise = true
    
    let startPoint: CGFloat = 2
    
    func positionTheBall(_ ball: SKShapeNode, prevBallRadius: CGFloat = 0) {
        let distanceToEarth: CGFloat = earth.radius + ball.radius + prevBallRadius * 2 + prevBallRadius * spaceFactor
        ball.position.x = distanceToEarth
        ball.position.y = ball.radius
        ball.position = startPointToPosition()
    }
    
    func positionTheBalls() {
        var prevBallRadius: CGFloat = 0
        for ball in balls {
            positionTheBall(ball, prevBallRadius: prevBallRadius)
            prevBallRadius += ball.radius
        }
    }
    
    func makeTheBallMove(_ ball: SKShapeNode, prevBallRadius: CGFloat = 0) {
        let totalRadius = earth.radius + ball.radius + prevBallRadius * 2 + prevBallRadius * spaceFactor
        var t = CGAffineTransform.identity.scaledBy(x: 1, y: clockwise ? -1 : 1)
        let trajectory: CGPath = .init(
            ellipseIn: .init(
                origin: .init(x: -totalRadius, y: -totalRadius),
                size: .init(width: totalRadius * 2, height: totalRadius * 2)
            ), transform: &t
        )
        func showArea() {
            let area = SKShapeNode(path: trajectory)
            addChild(area)
        }
        func keepGoingAroundACircle() {
            ball.run(
                .repeatForever(
                    .follow(
                        trajectory,
                        asOffset: false,
                        orientToPath: true,
                        speed: totalRadius / 1
                    )
                )
            )
        }
        keepGoingAroundACircle()
        //showArea()
    }
    
    func getPositionFromAngleOnCircle(radius: CGFloat, position: CGPoint, angle: CGFloat) -> CGPoint {
        return position + CGPoint(
            x: CGFloat(radius * cos(angle)),
            y: CGFloat(radius * sin(angle))
        )
    }
    
    func markStartPoint() {
        let r = earth.radius
        let p = earth.position
        let mark = SKShapeNode(circleOfRadius: 5)
        mark.position = getPositionFromAngleOnCircle(
            radius: r,
            position: p,
            angle: startPoint
        )
        mark.zPosition = 1
        addChild(mark)
    }
    
    func startPointToPosition() -> CGPoint {
        let r = earth.radius
        let p = earth.position
        return getPositionFromAngleOnCircle(
            radius: r,
            position: p,
            angle: startPoint
        )
    }
    
    override func sceneDidLoad() {
        markStartPoint()
        
        scaleTheSceneToView()
        centerEverything()
        addTheStuff()
                
        positionTheBalls()
    }
    
    func makeTheBallsMove() {
        var prevBallRadius: CGFloat = 0
        for ball in balls {
            makeTheBallMove(ball, prevBallRadius: prevBallRadius)
            prevBallRadius += ball.radius
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        makeTheBallsMove()
    }

}

let view = SKView(
    frame: .init(
        origin: .init(),
        size: .init(width: 500, height: 500)
    )
)

view.presentScene(TestScene())

PlaygroundPage.current.liveView = view
