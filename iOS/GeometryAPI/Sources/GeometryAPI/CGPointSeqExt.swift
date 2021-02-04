import CoreGraphics

//public struct PointSet {
//
//    public let points: [CGPoint]
//
//    public init(points: [CGPoint]) { self.points = points }
//
//    public var pointWithSmallestY: CGPoint? {
//        return points.min {
//            $0.y < $1.y
//        }
//    }
//
//    public static func dot(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
//        let ab = CGVector(dx: b.x - a.x, dy: b.y - a.y)
//        let bc = CGVector(dx: c.x - b.x, dy: c.y - b.y)
//        return (ab.dx * bc.dx) + (ab.dy * bc.dy)
//    }
//
//    public static func cross(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
//        return (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)
//    }
//
//    public static func angle(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
//        let ab = CGVector(dx: b.x - a.x, dy: b.y - a.y)
//        let bc = CGVector(dx: c.x - b.x, dy: c.y - b.y)
//        return dot(a: a, b: b, c: c) / (hypot(ab.dx, ab.dy) * hypot(bc.dx, bc.dy))
//    }
//
//    public static func isCounterClockwise(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> Bool {
//        return cross(a: p1, b: p2, c: p3) < 0
//    }
//
//    var convexHullPoints: [CGPoint]? {
//        let firstP = pointWithSmallestY
//        guard var currentP = firstP else { return nil }
//        var previousP: CGPoint = .init(x: currentP.x - 100, y: currentP.y)
//
//        var finalPoints: [CGPoint] = [currentP]
//
//        repeat {
//            let counterClockwisePoints = points.filter {
//                PointSet.isCounterClockwise(
//                    p1: previousP,
//                    p2: currentP,
//                    p3: $0
//                )
//            }
//            guard let smallestCCPoint = counterClockwisePoints.min(by: {
//                PointSet.angle(a: previousP, b: currentP, c: $0) > PointSet.angle(a: previousP, b: currentP, c: $1)
//            }) else { return nil }
//            previousP = currentP
//            currentP = smallestCCPoint
//            if currentP != firstP { finalPoints.append(smallestCCPoint) }
//        } while currentP != firstP
//        return finalPoints
//    }
//
//    public var convexHull: CGPath? {
//        guard let points = convexHullPoints else { return nil }
//        let path = CGMutablePath()
//        path.addLines(between: points)
//        path.closeSubpath()
//        return path
//    }
//
//    public var path: CGPath {
//        let path = CGMutablePath()
//        path.addLines(between: points)
//        path.closeSubpath()
//        return path
//    }
//
//}

extension Sequence where Element == CGPoint {
    
    public var pointWithSmallestY: CGPoint? {
        return self.min {
            $0.y < $1.y
        }
    }

    public static func dot(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
        let ab = CGVector(dx: b.x - a.x, dy: b.y - a.y)
        let bc = CGVector(dx: c.x - b.x, dy: c.y - b.y)
        return (ab.dx * bc.dx) + (ab.dy * bc.dy)
    }
    
    public static func cross(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
        return (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)
    }
    
    public static func angle(a: CGPoint, b: CGPoint, c: CGPoint) -> CGFloat {
        let ab = CGVector(dx: b.x - a.x, dy: b.y - a.y)
        let bc = CGVector(dx: c.x - b.x, dy: c.y - b.y)
        return dot(a: a, b: b, c: c) / (hypot(ab.dx, ab.dy) * hypot(bc.dx, bc.dy))
    }
    
    public static func isCounterClockwise(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> Bool {
        return cross(a: p1, b: p2, c: p3) < 0
    }
    
    public var convexHull: CGPath? {
        guard let points = convexHullPoints else { return nil }
        let path = CGMutablePath()
        path.addLines(between: points)
        path.closeSubpath()
        return path
    }
    
    public var path: CGPath {
        let path = CGMutablePath()
        path.addLines(between: Array(self))
        path.closeSubpath()
        return path
    }
    
    var convexHullPoints: [CGPoint]? {
        let firstP = pointWithSmallestY
        guard var currentP = firstP else { return nil }
        var previousP: CGPoint = .init(x: currentP.x - 100, y: currentP.y)
        
        var finalPoints: [CGPoint] = [currentP]
        
        repeat {
            let counterClockwisePoints = self.filter {
                Self.isCounterClockwise(
                    p1: previousP,
                    p2: currentP,
                    p3: $0
                )
            }
            guard let smallestCCPoint = counterClockwisePoints.min(by: {
                Self.angle(a: previousP, b: currentP, c: $0) > Self.angle(a: previousP, b: currentP, c: $1)
            }) else { return nil }
            previousP = currentP
            currentP = smallestCCPoint
            if currentP != firstP { finalPoints.append(smallestCCPoint) }
        } while currentP != firstP
        return finalPoints
    }
    
}
