import SwiftUI

enum AsteroidWatchAPIResult {
    case asteroids([Asteroid])
    case error(APIError)
}

protocol AsteroidWatchAPIProtocol {
    func getAsteroids(dateRange: ClosedRange<Date>) -> Future<[Asteroid], APIError>
    
//    func getAsteroids1(dateRange: ClosedRange<Date>) -> Future<[Asteroid], APIError>
//    func getAsteroids2(dateRange: ClosedRange<Date>, handle: (Result<[Asteroid], APIError>) -> ())
//    func getAsteroids3(dateRange: DateRange, handle: (Result<[Asteroid], APIError>) -> ())
//    func getAsteroids4(dateRange: DateRange, handle: (AsteroidWatchAPIResult) -> ())
//    func getAsteroids5(dateRange: DateRange, handle: ([Asteroid]?, APIError?) -> ())
}
