import XCTest
import AsteroidWatchAPI

class MockAPITests: XCTestCase {
        
    let mockAPI = MockAPI()
    
    var disposableBag: [AnyCancellable] = []
    
    func test_asteroids() {
        let exp = expectation(description: "")
                
        let dateRange = ClosedRange<AsteroidWatchAPI.Date>.init(uncheckedBounds: (
            lower: Date.create(day: 26, month: 1, year: 2021)!,
            upper: Date.create(day: 30, month: 1, year: 2021)!
        ))
        let futureAsteroids = mockAPI.getAsteroids(
            dateRange: dateRange
        )
        
        futureAsteroids.sink(
            receiveCompletion: { _ in
                exp.fulfill()
            },
            receiveValue: { value in
                XCTAssert(value.count == 1)
            }
        ).store(in: &disposableBag)
        
        wait(for: [exp], timeout: 3)
    }
    
}
