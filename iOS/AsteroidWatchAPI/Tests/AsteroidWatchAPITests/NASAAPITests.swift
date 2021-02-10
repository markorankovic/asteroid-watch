import XCTest
import AsteroidWatchAPI

class NASAAPITests: XCTestCase {
    
    let api = NASAAPI()
    
    var disposableBag: [AnyCancellable] = []
        
//    func test_NASAAPI2() {
//        let exp = expectation(description: "")
//
//        let dateRange = ClosedRange<AsteroidWatchAPI.Date>.init(uncheckedBounds: (
//            lower: Date.create(day: 23, month: 5, year: 2021)!,
//            upper: Date.create(day: 26, month: 5, year: 2021)!
//        ))
//
//        let futureAsteroids = api.getAsteroids(
//            dateRange: dateRange
//        )
//
//        futureAsteroids.sink(
//            receiveCompletion: { _ in
//                exp.fulfill()
//            },
//            receiveValue: { value in
//                XCTAssert(value.count > 0)
//            }
//        ).store(in: &disposableBag)
//
//        wait(for: [exp], timeout: 3)
//    }
    
    func test_NASAAPI() {
        let exp = expectation(description: "")
        
        let dateRange = ClosedRange<AsteroidWatchAPI.Date>.init(uncheckedBounds: (
            lower: Date.create(day: 23, month: 5, year: 2021)!,
            upper: Date.create(day: 27, month: 5, year: 2021)!
        ))
        
        let futureAsteroids = api.getAsteroids(
            dateRange: dateRange
        )
        
        futureAsteroids.sink(
            receiveCompletion: { _ in
                exp.fulfill()
            },
            receiveValue: { value in
                XCTAssert(value.count == 39)
            }
        ).store(in: &disposableBag)
        
        wait(for: [exp], timeout: 10)
    }
    
    func test_jsonToNASAObject() {
        if let filepath = Bundle.module.url(forResource: "exampleAsteroids", withExtension: "json") {
            do {
                let json = try String(contentsOf: filepath).data(using: .utf8)!
                _ = try JSONDecoder().decode(NASAAPI.NASAObject.self, from: json)
                XCTAssert(true)
            } catch {
                print(error)
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
}
