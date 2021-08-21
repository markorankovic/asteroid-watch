import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        SceneView(
            scene: SpeedComparisonScene(asteroids: []),
            options: [.allowsCameraControl],
            preferredFramesPerSecond: 60,
            antialiasingMode: .multisampling4X
        ).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
