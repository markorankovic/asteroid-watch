public struct MockAPI: AsteroidWatchAPIProtocol {
    
    var isReturningError: Bool = false
    
    let asteroids = [Asteroid(id: "grehre", name: "Apollo123", diameter: 30, missDistance: 3000, velocity: 1000, date: .init(day: 26, month: 5, year: 2021), isHazardous: false)]
    
    public init() { }
    
    private func getAsteroids(dateRange: ClosedRange<Date>) -> [Asteroid] {
        return asteroids.filter { asteroid in
            guard let date = asteroid.date else { return false }
            let asteroidDays = (date.day + date.month * 30 + date.year * 365)
            
            let lbDays = (dateRange.lowerBound.day + dateRange.lowerBound.month * 30 + dateRange.lowerBound.year * 365)
            
            let ubDays = (dateRange.upperBound.day + dateRange.upperBound.month * 30 + dateRange.upperBound.year * 365)
            
            return lbDays <= asteroidDays && asteroidDays <= ubDays
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
