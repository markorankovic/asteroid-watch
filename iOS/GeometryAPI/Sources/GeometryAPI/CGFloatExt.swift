import CoreGraphics

public extension CGFloat {
    
    func randomPointsAlongRadius(count: Int) -> [CGPoint] {
        let angles = (0..<count).map { _ in CGFloat.random(in: 0...2*CGFloat.pi) }
        return angles.map { a in CGPoint(x: self * cos(a), y: self * sin(a)) }
    }
    
}
