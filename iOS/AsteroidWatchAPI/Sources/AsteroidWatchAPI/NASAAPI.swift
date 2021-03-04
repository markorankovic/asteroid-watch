public struct NASAAPI: AsteroidWatchAPIProtocol {
    let baseURL: String = "https://api.nasa.gov"
    let endpoint: String = "/neo/rest/v1/feed"
    let APIKEY = "uxickliHQnKSJqa7sl3gfdWt6Fw1Oct7rzzxDzHB"
        
    public static func nasaObjectToAsteroids(_ nasaObject: NASAObject) -> [Asteroid] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let neos = nasaObject.near_earth_objects.values.flatMap { $0 }
        return neos.map({ neo in
            print(neo.close_approach_data[0].close_approach_date)
            let date = dateFormatter.date(from: neo.close_approach_data[0].close_approach_date)
            
            let diameter = (neo.estimated_diameter.meters.estimated_diameter_min + neo.estimated_diameter.meters.estimated_diameter_max) / 2
                        
            let velocity = Double(neo.close_approach_data[0].relative_velocity.kilometers_per_hour)!
            
            let missDistance = Double(neo.close_approach_data[0].miss_distance.kilometers)!
            
            let asteroid = Asteroid(
                id: neo.id,
                name: neo.name,
                diameter: diameter,
                missDistance: missDistance,
                velocity: velocity,
                date: date,
                isHazardous: neo.is_potentially_hazardous_asteroid
            )

            return asteroid
        })
    }
    
    public static func jsonToNASAObject() -> NASAObject? {
        if let filepath = Bundle.module.url(forResource: "exampleAsteroids", withExtension: "json") {
            do {
                let json = try String(contentsOf: filepath).data(using: .utf8)!
                return try JSONDecoder().decode(NASAObject.self, from: json)
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
    
    public init() { }
    
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    public func getAsteroids(dateRange: ClosedRange<Date>) -> Future<[Asteroid], APIError> {
        
        let query: [URLQueryItem] = [
            URLQueryItem(
                name: "start_date",
                value: formatter.string(from: dateRange.lowerBound)
            ),
            URLQueryItem(
                name: "end_date",
                value: formatter.string(from: dateRange.upperBound)
            ),
            URLQueryItem(
                name: "api_key",
                value: APIKEY
            )
        ]
        
        guard var c = URLComponents(string: baseURL + endpoint) else {
            return Future { promise in
                return promise(.failure(.someError("Adding url components error")))
            }
        }
        c.queryItems = query
                
        guard let url = c.url else {
            return Future { promise in
                return promise(.failure(.someError("Getting url from components error")))
            }
        }
        
        print(url)
        
        return request(url: url)
    }
    
    let session = URLSession(configuration: .default)
    
    func request(url: URL) -> Future<[Asteroid], APIError> {
        return Future<[Asteroid], APIError> { promise in
            let req = URLRequest(url: url)
            let t = CFAbsoluteTimeGetCurrent()
            print("Prepared for URL session")
            URLSession.DataTaskPublisher(
                request: req,
                session: session
            )
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): return promise(.failure(.someError(error.localizedDescription)))
                    }
                },
                receiveValue: { value in
                    do {
                        let object = try JSONDecoder().decode(NASAObject.self, from: value.data)
                        print("NASA object received \(CFAbsoluteTimeGetCurrent() - t)")
                        return promise(.success(NASAAPI.nasaObjectToAsteroids(object)))
                    } catch {
                        return promise(.failure(.someError(value.response.description)))
                    }
                }
            ).store(in: &s)
        }
    }

}

var s: [AnyCancellable] = []
