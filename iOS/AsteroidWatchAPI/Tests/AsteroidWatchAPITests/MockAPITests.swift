import XCTest
import AsteroidWatchAPI

class MockAPITests: XCTestCase {
        
    let mockAPI = MockAPI()
    
    var disposableBag: [AnyCancellable] = []
    
    func test_asteroids() {
        let exp = expectation(description: "")
                
        let dateRange = ClosedRange<AsteroidWatchAPI.Date>.init(uncheckedBounds: (
            lower: Date.create(day: 23, month: 5, year: 2021)!,
            upper: Date.create(day: 28, month: 5, year: 2021)!
        ))
        let futureAsteroids = mockAPI.getAsteroids(
            dateRange: dateRange
        )
        
        futureAsteroids.sink(
            receiveCompletion: { _ in
                exp.fulfill()
            },
            receiveValue: { value in
                XCTAssert(value.count > 0)
            }
        ).store(in: &disposableBag)
        
        wait(for: [exp], timeout: 10)
    }
    
}
