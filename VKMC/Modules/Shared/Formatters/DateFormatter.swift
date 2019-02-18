import Foundation

class VKMCDateFormatter {
    static let shared = VKMCDateFormatter()
    
    lazy var dayShortMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
    
    lazy var hourMinutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
