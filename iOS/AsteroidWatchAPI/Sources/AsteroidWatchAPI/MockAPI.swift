public struct MockAPI: AsteroidWatchAPIProtocol {
    
    let asteroids: [Asteroid] = {
        guard let nasaobj = NASAAPI.jsonToNASAObject() else { return [] }
        return NASAAPI.nasaObjectToAsteroids(nasaobj)
    }()
    
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
