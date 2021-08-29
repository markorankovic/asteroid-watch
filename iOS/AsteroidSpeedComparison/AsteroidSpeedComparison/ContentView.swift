import SwiftUI
import SceneKit
import AsteroidWatchAPI

struct ContentView: View {
    
    let asteroids: [Asteroid]
    
    class MyState: ObservableObject {
        let scene = SpeedComparisonScene(named: "SpeedComparison2.scn")!
    }
    
    @StateObject var state = MyState()
    
    var body: some View {
        SceneView(
            scene: state.scene,
            options: [.allowsCameraControl],
            preferredFramesPerSecond: 60,
            antialiasingMode: .multisampling4X
        )
        .ignoresSafeArea()
        .onAppear {
            state.scene.asteroids = asteroids
            state.scene.startScene()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            asteroids: [
                Asteroid(
                    id: "2517681",
                    name: "2015 DE198",
                    diameter: (1081.533506775 + 483.6764882185) / 2,
                    missDistance: 28047702.990978837,
                    velocity: 45093.5960746662,
                    date: nil,
                    isHazardous: true
                ),
                Asteroid(
                    id: "2517681",
                    name: "2015 DE198",
                    diameter: (1081.533506775 + 483.6764882185) / 2,
                    missDistance: 28047702.990978837,
                    velocity: 45093.5960746662,
                    date: nil,
                    isHazardous: true
                ),
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
        ).previewLayout(.fixed(width: 700, height: 300))
    }
}
