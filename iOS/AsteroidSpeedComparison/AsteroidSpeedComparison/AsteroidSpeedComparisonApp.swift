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
                    diameter: .random(in: 100...2000),
                    missDistance: .random(in: 40_000_000...100_000_000),
                    velocity: .random(in: 40_000_000...100_000_000),
                    date: nil,
                    isHazardous: .random()
                )
            })
        }
    }
}
