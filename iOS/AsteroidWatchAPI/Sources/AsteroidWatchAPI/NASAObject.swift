public struct NASAObject: Codable {
    var near_earth_objects: [String: [NEO]]
    struct NEO: Codable {
        var id: String
        var name: String
        var estimated_diameter: EstimatedDiameter
        struct EstimatedDiameter: Codable {
            var meters: Meters
            struct Meters: Codable {
                var estimated_diameter_min: Double
                var estimated_diameter_max: Double
            }
        }
        var is_potentially_hazardous_asteroid: Bool
        var close_approach_data: [CloseApproachDataItem]
        struct CloseApproachDataItem: Codable {
            var close_approach_date: String
            var relative_velocity: RelativeVelocity
            struct RelativeVelocity: Codable {
                var kilometers_per_hour: String
            }
            var miss_distance: MissDistance
            struct MissDistance: Codable {
                var kilometers: String
            }
        }
    }
}
