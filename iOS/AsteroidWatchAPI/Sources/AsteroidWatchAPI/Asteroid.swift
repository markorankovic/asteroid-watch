public struct Asteroid: Codable, Hashable {
    public var id: String
    public var name: String
    public var diameter: Double
    public var missDistance: Double
    public var velocity: Double
    public var date: Date?
    public var isHazardous: Bool
            
    public init(
        id: String,
        name: String,
        diameter: Double,
        missDistance: Double,
        velocity: Double,
        date: Date?,
        isHazardous: Bool
        ) {
        self.id = id
        self.name = name
        self.diameter = diameter
        self.missDistance = missDistance
        self.velocity = velocity
        self.date = date
        self.isHazardous = isHazardous
    }
}
