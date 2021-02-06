import SwiftUI

public enum AsteroidWatchAPIResult {
    case asteroids([Asteroid])
    case error(APIError)
}

public protocol AsteroidWatchAPIProtocol {
    func getAsteroids(dateRange: ClosedRange<Date>) -> Future<[Asteroid], APIError>
}
