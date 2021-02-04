import SpriteKit
import GameplayKit
import AsteroidWatchAPI

class GameScene: SKScene {
    
    var bag: Set<AnyCancellable> = []
    
    override func sceneDidLoad() {
        Timer.publish(
            every: 1,
            on: .main,
            in: .default
        )
        .autoconnect()
        .sink { [weak self] _ in
            self?.update()
        }
        .store(in: &bag)
    }
    
    func update() {
        guard let asteroid = AsteroidGenerator.generateAsteroid() else { return }
        removeAllChildren()
        addChild(asteroid)
    }
    
}
