import SceneKit

extension SCNNode {
    
    var width: CGFloat {
        CGFloat((boundingBox.max.x - boundingBox.min.x) * scale.x)
    }
    
    var height: CGFloat {
        CGFloat((boundingBox.max.y - boundingBox.min.y) * scale.y)
    }
    
    var depth: CGFloat {
        CGFloat((boundingBox.max.z - boundingBox.min.z) * scale.z)
    }

}
