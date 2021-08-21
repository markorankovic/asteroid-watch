import SwiftUI
import SceneKit
import AsteroidWatchAPI

struct ContentView: View {
    
    let asteroids: [Asteroid]
    
    var body: some View {
        SceneView(
            scene: SpeedComparisonScene(named: "SizeComparison2.scn"),
            options: [.allowsCameraControl],
            preferredFramesPerSecond: 60,
            antialiasingMode: .multisampling4X
        ).ignoresSafeArea()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(asteroids: [])
    }
}
