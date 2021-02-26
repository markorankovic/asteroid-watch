import SwiftUI
import SpriteKit
import SceneKit
import AsteroidWatchAPI

struct ComparisonSequenceView: View {
    let comparisonType: Comparison
    
    //let comparisonSceneViewController: SizeComparisonScene3D
    
    var body: some View {
        SceneView()
        //comparisonSceneViewController
//        Group {
//            SceneView(
//                scene: SCNScene(),
//                pointOfView: .none,
//                options: [],
//                preferredFramesPerSecond: 60,
//                antialiasingMode: .multisampling4X,
//                delegate: nil,
//                technique: nil
//            )
//        }.edgesIgnoringSafeArea(.all)
    }
}

//struct ComparisonSequenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComparisonSequenceView(
//            comparisonType: .speed,
//            comparisonSceneViewController: SizeComparisonScene3D(
//                asteroids: [
//                    Asteroid(
//                        id: "2517681",
//                        name: "2015 DE198",
//                        diameter: (1081.533506775 + 483.6764882185) / 2,
//                        missDistance: 28047702.990978837,
//                        velocity: 45093.5960746662,
//                        date: nil,
//                        isHazardous: true
//                    )
//                ]
//            )
//        )
//    }
//}
