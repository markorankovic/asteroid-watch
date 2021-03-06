import SpriteKit
import AsteroidWatchAPI

public class LoadingScene: SKScene {
                
    public override func sceneDidLoad() {
        backgroundColor = .clear
        
//        let n = Int(size.width * size.height) / 1000
//        print(n)
//        addChildren(
//            stars(
//                count: n
//            )
//        )
        
        Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink{ _ in
            let dim = CGFloat.random(in: 20...100)
            let asteroid = AsteroidGenerator.generateAsteroid(
                size: .init(width: dim, height: dim)
            )!
            asteroid.position = .init(
                x: CGFloat.random(in: self.size.width...self.size.width + 2), y: CGFloat.random(in: 0...self.size.height)
            )
            asteroid.run(.moveTo(x: -asteroid.frame.width - 100, duration: 10))
            self.addChild(asteroid)
        }.store(in: &bag)
    }
    
    var bag: [AnyCancellable] = []
    
    func stars(count: Int) -> [SKNode] {
        return (1...count).map { _ in
            let star = SKShapeNode(
                circleOfRadius: CGFloat.random(in: 0.01...1)
            )
            star.position = .init(
                x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height)
            )
            star.fillColor = .white
            return star
        }
    }
    
}
