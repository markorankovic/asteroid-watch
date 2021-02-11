public enum Comparison: String, CaseIterable, Identifiable {
    public var id: String { return rawValue }
    
    case size = "Size"
    case speed = "Speed"
    case miss = "Miss"
}
