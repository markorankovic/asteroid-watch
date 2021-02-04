import CoreGraphics

extension CGSize {
    public func randomPoints(count: Int) -> [CGPoint] {
        return (0..<count).map { _ in
            CGPoint(x: .random(in: 0..<width), y: .random(in: 0..<height))
        }
    }
}
