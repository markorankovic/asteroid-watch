extension Date {
    
    public static func create(day: Int, month: Int, year: Int) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM/dd"
        let dayString = day < 10 ? "0\(day)" : "\(day)"
        let someDateTime = formatter.date(from: "\(year)/\(month)/\(dayString)")
        return someDateTime
    }
    
}
