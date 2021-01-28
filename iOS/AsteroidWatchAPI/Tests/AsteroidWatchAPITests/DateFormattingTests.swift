
import XCTest
import AsteroidWatchAPI

private let formatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "dd-MM-yyyy"
    return f
}()

class DateFormattingTests: XCTestCase {
    
    func test_ddMMYY_To_Date() {
        guard let _ = Date.create(day: 29, month: 11, year: 2021) else {
            return XCTFail()
        }
    }
    
    func test_dateToString() {
        guard let date = Date.create(day: 29, month: 11, year: 2021) else {
            return XCTFail()
        }
        XCTAssert(formatter.string(from: date) == "29-11-2021")
    }
    
    func test_stringToDate() {
        let str = "29-11-2021"
        guard let _ = formatter.date(from: str) else {
            return XCTFail()
        }
    }
    
}
