import SwiftUI
import AsteroidWatchAPI

@main
struct AsteroidSpeedComparisonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(asteroids: (1...10).map { i in
                Asteroid(
                    id: "\(i)",
                    name: "Asteroid \(i)",
                    diameter: .random(in: 1...2),
                    missDistance: 1,
                    velocity: .random(in: 1...100),
                    date: nil,
                    isHazardous: .random()
                )
            })
        }
    }
}
