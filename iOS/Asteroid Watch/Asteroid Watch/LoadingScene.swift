import SpriteKit
import AsteroidWatchAPI

public class LoadingScene: SKScene {
                
    public override func sceneDidLoad() {
        backgroundColor = .clear
                
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
        
        DispatchQueue.main.async {
            let downloadingText = SKLabelNode(text: "Loading Data from NASA")
            downloadingText.position.x += self.size.width / 2
            downloadingText.position.y += self.size.height / 2
            downloadingText.zPosition = 5
            downloadingText.alpha = 0
            downloadingText.run(
                SKAction.sequence([
                    .fadeAlpha(to: 0.5, duration: 1),
                    .repeatForever(
                        SKAction.sequence([
                            .fadeAlpha(to: 1, duration: 1),
                            .fadeAlpha(to: 0.5, duration: 1),
                        ])
                    )
                ])
            )
            self.addChild(downloadingText)
        }
    }
    
    var bag: [AnyCancellable] = []
        
}
