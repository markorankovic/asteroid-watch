public struct MockAPI: AsteroidWatchAPIProtocol {
    
    var isReturningError: Bool = false
    
    let asteroids = [
        Asteroid(
            id: "grehre",
            name: "Apollo123",
            diameter: 30,
            missDistance: 3000,
            velocity: 1000,
            date: Date.create(day: 29, month: 1, year: 2021),
            isHazardous: false
        )
    ]
    
    public init() { }
    
    private func getAsteroids(dateRange: ClosedRange<Date>) -> [Asteroid] {
        return asteroids.filter { asteroid in
            guard let date = asteroid.date else { return false }
            return dateRange.lowerBound <= date && date <= dateRange.upperBound
        }
    }
    
    public func getAsteroids(dateRange: ClosedRange<Date>) -> Future<[Asteroid], APIError> {
        return Future { promise in
            return promise(
                .success(
                    getAsteroids(
                        dateRange: dateRange
                    )
                )
            )
        }
    }
    
}
