import Foundation

extension Date {
    func timeAgoDisplay() -> String? {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = minute * 60
        let day = hour * 24
        
        var timePart = ""
        if secondsAgo < minute {
            timePart = LocalizableKeys.localized(key: .seconds, with: secondsAgo)
        } else if secondsAgo < hour {
            timePart = LocalizableKeys.localized(key: .minutes, with: secondsAgo / minute)
        } else if secondsAgo < day {
            timePart = LocalizableKeys.localized(key: .seconds, with: secondsAgo / hour)
        } else {
            // Need to display date & time
            return nil
        }
        
        return timePart + " \(LocalizedString.localized(key: .ago))"
    }
    
    func timeDisplay() -> String {
        let calendar = NSCalendar.current
        
        if calendar.isDateInToday(self), let timeAgoString = timeAgoDisplay() {
            return timeAgoString
        } else if calendar.isDateInYesterday(self) {
            let yesterday = LocalizedString.localized(key: .yesterday).capitalized
            let time = VKMCDateFormatter.shared.hourMinutesFormatter.string(from: self)
            return "\(yesterday) \(LocalizedString.localized(key: .at)) \(time)"
        } else {
            let date = VKMCDateFormatter.shared.hourMinutesFormatter.string(from: self)
            let time = VKMCDateFormatter.shared.hourMinutesFormatter.string(from: self)
            return "\(date) \(LocalizedString.localized(key: .at)) \(time)"
        }
    }
}
