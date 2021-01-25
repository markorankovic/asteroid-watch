public struct Date: Codable, Comparable {
    
    public static func < (lhs: Date, rhs: Date) -> Bool {
        lhs.day + lhs.month * 30 + lhs.year * 365 < rhs.day + rhs.month * 30 + rhs.year * 365
    }
    
    let day: Int
    let month: Int
    let year: Int
    
    public init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
}
