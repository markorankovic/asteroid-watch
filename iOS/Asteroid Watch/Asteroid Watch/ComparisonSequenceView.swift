import SwiftUI
import SceneKit
import AsteroidWatchAPI

struct ComparisonSequenceView: View {
    let comparisonScene: SizeComparisonScene3D

    var body: some View {
        SceneView(
            scene: comparisonScene,
            pointOfView: nil,
            options: [],
            preferredFramesPerSecond: 60,
            antialiasingMode: .multisampling4X,
            delegate: nil,
            technique: nil
        ).gesture(DragGesture().onChanged { gesture in
            let speed: CGFloat = CGFloat(gesture.predictedEndLocation.x - gesture.location.x) * 5

            comparisonScene.handlePan(speed)
        })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonSequenceView(comparisonScene: SizeComparisonScene3D(asteroids: [
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
        ]))
    }
}
