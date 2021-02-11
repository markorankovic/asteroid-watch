import SwiftUI
import SpriteKit
import SceneKit

struct ComparisonSequenceView: View {
    let is3D: Bool
    
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
        ComparisonSequenceView(is3D: false)
    }
}
