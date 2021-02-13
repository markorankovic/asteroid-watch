import SwiftUI
import SpriteKit
import SceneKit
import AsteroidWatchAPI

struct ComparisonSequenceView: View {
    let is3D: Bool
    let comparisonType: Comparison
    let asteroids: [Asteroid]
    
    var body: some View {
        Group {
            if is3D {
                SceneView()
            } else {
                SpriteView(scene: SKScene())
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ComparisonSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonSequenceView(
            is3D: false,
            comparisonType: .speed,
            asteroids: [
                Asteroid(
                    id: "2517681",
                    name: "2015 DE198",
                    diameter: (1081.533506775 + 483.6764882185) / 2,
                    missDistance: 28047702.990978837,
                    velocity: 45093.5960746662,
                    date: nil,
                    isHazardous: true
                )
            ]
        )
    }
}
