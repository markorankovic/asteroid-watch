public struct Asteroid: Codable {
    var id: String
    var name: String
    var diameter: Double
    var missDistance: Double
    var velocity: Double
    var date: Date?
    var isHazardous: Bool
}
