import XCTest
@testable import GeometryAPI

import CoreGraphics

final class GeometryAPITests: XCTestCase {
    
    let randomPoints = PointSet(
        points: CGSize(
            width: 400,
            height: 400
        ).randomPoints(
            count: 10
        )
    )
        
    let points = PointSet(
        points: [
            CGPoint(x: -100, y: 235 / 2),
            CGPoint(x: -64, y: 323 / 2),
            CGPoint(x: -26, y: 432 / 2),
            CGPoint(x: -25, y: 341 / 2),
            CGPoint(x: -57, y: 145 / 2),
        ]
    )
    
    func test_SmallestY() {
        guard let point = points.pointWithSmallestY else { return XCTFail() }
        XCTAssert(CGFloat(145 / 2) == point.y)
    }
    
    func test_PointsAreCounterClockwise() {
        let points = [
            CGPoint(x: -57, y: 72),
            CGPoint(x: -25, y: 170),
            CGPoint(x: -26, y: 216)
        ]
        
        XCTAssert(
            PointSet.isCounterClockwise(
                p1: points[0],
                p2: points[1],
                p3: points[2]
            )
        )
    }
    
    func test_PointsAreNotCounterClockwise() {
        let points = [
            CGPoint(x: -157, y: 72),
            CGPoint(x: -52, y: 72),
            CGPoint(x: -205, y: 170)
        ]
        
        XCTAssertFalse(
            !PointSet.isCounterClockwise(
                p1: points[0],
                p2: points[1],
                p3: points[2]
            )
        )
    }
    
    func test_ConvexHull() {
        XCTAssert(points.convexHullPoints != nil)
    }
    
}
