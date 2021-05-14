import AsteroidWatchAPI

public func jsonExampleToAsteroids() -> [Asteroid] {
    do {
        let path = Bundle.main.path(forResource: "exampleAsteroids.json", ofType: nil)!
        let json = try String(
            contentsOf: URL(fileURLWithPath: path)
        ).data(using: .utf8)!
        let nasaObject = try JSONDecoder().decode(NASAObject.self, from: json)
        let asteroids = NASAAPI.nasaObjectToAsteroids(nasaObject)
        print("Asteroids: \(asteroids)")
        return asteroids
    } catch {
        return []
    }
}
