//
//  Date+Tool.swift
//  RealTimeBid
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 JAVIS. All rights reserved.
//

fileprivate let D_MINUTE     = 60.0
fileprivate let D_HOUR       = 3600.0
fileprivate let D_DAY        = 86400.0
fileprivate let D_WEEK       = 604800.0
fileprivate let D_YEAR       = 31536000.0

extension Date
{
    
    static func date(string: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date ?? Date.init()
    }
    
    func timeIntervalDescription() -> String
    {
        let timeInterval = -self.timeIntervalSinceNow
        if timeInterval < D_MINUTE {
            return "1分钟内"
        } else if timeInterval < D_HOUR {
            return "\(Int(timeInterval / D_MINUTE))分钟前"
        } else if timeInterval < D_DAY {
            return "\(Int(timeInterval / D_HOUR))小时前"
        } else if timeInterval < D_DAY * 30 {//within 30 days
            return "\(Int(timeInterval / D_DAY))天前"
        } else if timeInterval < D_YEAR { //30 days to a year
            return String.string(date: self, dateFormat: "M'月'd'日'")
        } else {
            return String.string(date: self, dateFormat: "yy M'月'd'日'")
        }
    }

    
    func minuteDescription() -> String
    {
        var format = ""
        if isToday() {
            format = "HH:mm"
        } else if isYesterday() {//one day ago
            format = "'昨天' HH:mm"
        } else if isThisWeek() {//within a week
            format = "EEE HH:mm"
        } else if isThisYear() { //within a year
            format = "MM-dd HH:mm"
        } else {
            format = "yy-MM-dd HH:mm"
        }
        return String.string(date: self, dateFormat: format)
    }
    
    
    
    /// 明天
    static func tomorrow() -> Date
    {
        return Date.dateWithFromNow(aDays: 1)
    }
    
    /// 昨天
    static func yesterday() -> Date
    {
        return Date.dateWithBeforeNow(aDays: 1)
    }
    
    /// 当天开始时
    func dateAtStart() -> Date
    {
        var components = Date.dateComponents(from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components) ?? self
    }
    
    
    // MARK: - 日期的判断
    /// 是今天吗？
    func isToday() -> Bool
    {
        return isSameDay(Date.init())
    }
    
    /// 是明天吗？
    func isTomorrow() -> Bool
    {
        return isSameDay(Date.tomorrow())
    }
    
    /// 是昨天吗？
    func isYesterday() -> Bool
    {
        return isSameDay(Date.yesterday())
    }

    
    
    /// 是这周吗？
    func isThisWeek() -> Bool
    {
        return isSameWeek(Date.init())
    }
    
    /// 是下周吗？
    func isNextWeek() -> Bool
    {
        let newDate = Date.dateWithFromNow(aDays: 7)
        return self.isSameWeek(newDate)
    }
    
    /// 是上周吗？
    func isLastWeek() -> Bool
    {
        let newDate = Date.dateWithBeforeNow(aDays: 7)
        return self.isSameWeek(newDate)
    }
    

    
    /// 是这月吗？
    func isThisMonth() -> Bool
    {
        return isSameMonth(Date.init())
    }
    
    /// 是这年吗？
    func isThisYear() -> Bool
    {
        return isSameYear(Date.init())
    }
    
    /// 是下年吗？
    func isNextYear() -> Bool
    {
        let components1 = Date.dateComponents(from: self)
        let components2 = Date.dateComponents(from: Date.init())
        
        return (components1.year == components2.year! + 1)
    }
    
    /// 是上年吗？
    func isLastYear() -> Bool
    {
        let components1 = Date.dateComponents(from: self)
        let components2 = Date.dateComponents(from: Date.init())
        
        return (components1.year == components2.year! - 1)
    }
    
    
    
    /// 早于日期
    func isEarlier(_ aDate: Date) -> Bool {
        return self.compare(aDate) == .orderedAscending
    }
    
    /// 迟于日期
    func isLater(_ aDate: Date) -> Bool {
        return self.compare(aDate) == .orderedDescending
    }
    
    /// 是在过去
    func isInPast() -> Bool
    {
        return self.isEarlier(Date.init())
    }

    /// 在未来
    func isInFuture() -> Bool
    {
        return self.isLater(Date.init())
    }
    
    
    /// 通常周末
    func isTypicallyWeekend() -> Bool
    {
        let components = Date.dateComponents(from: self)
        if (components.weekday == 6) || (components.weekday == 7) {
            return true
        } else {
            return false
        }
    }
    
    /// 通常工作日
    func isTypicallyWorkday() -> Bool
    {
        return !isTypicallyWeekend()
    }

    
    // MARK: - 日期比较
    /// 返回self是aDate之后第几分钟
    func minutesAfter(aDate: Date) -> Int
    {
        let ti = self.timeIntervalSince(aDate)
        return Int(ti / D_MINUTE);
    }
    /// 返回self是aDate之前第几分钟
    func minutesBefore(aDate: Date) -> Int
    {
        let ti = aDate.timeIntervalSince(self)
        return Int(ti / D_MINUTE);
    }
    
    /// 返回self是aDate之后第几小时
    func hoursAfter(aDate: Date) -> Int
    {
        let ti = self.timeIntervalSince(aDate)
        return Int(ti / D_HOUR);
    }
    /// 返回self是aDate之前第几小时
    func hoursBefore(aDate: Date) -> Int
    {
        let ti = aDate.timeIntervalSince(self)
        return Int(ti / D_HOUR);
    }
    
    /// 返回self是aDate之后第几天
    func daysAfter(aDate: Date) -> Int
    {
        let ti = self.timeIntervalSince(aDate)
        return Int(ti / D_DAY);
    }
    /// 返回self是aDate之前第几天
    func daysBefore(aDate: Date) -> Int
    {
        let ti = aDate.timeIntervalSince(self)
        return Int(ti / D_DAY);
    }
    
    
    // MARK: - 日期组件
    /// 最近的小时
    func nearestHour() -> Int
    {
        let newDate = self.dateByAdding(aMinutes: 30)
        return newDate.hour()
    }
    func hour() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.hour ?? 0
    }
    func minute() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.minute ?? 0
    }
    func seconds() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.second ?? 0
    }
    func day() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.day ?? 0
    }
    func month() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.month ?? 0
    }
    /// 当年第几周
    func week() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.weekOfYear ?? 0
    }
    func weekday() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.weekday ?? 0
    }
    /// 当月第几周
    func weekdayOrdinal() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.weekdayOrdinal ?? 0
    }
    func year() -> Int
    {
        let components = Date.dateComponents(from: self)
        return components.year ?? 0
    }
}

extension Date
{
    static func dateComponents(from date: Date) -> DateComponents
    {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .weekdayOrdinal]
        var calendar = Calendar.current
        calendar.locale = Locale.init(identifier: "zh_CN")
        return calendar.dateComponents(components, from: date)
    }
    
    func componentsOffset(fromDate aDate: Date) -> DateComponents
    {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .weekdayOrdinal]
        var calendar = Calendar.current
        calendar.locale = Locale.init(identifier: "zh_CN")
        return calendar.dateComponents(components, from: aDate, to: self)
    }
    
    /// 是相同的一天吗？
    func isSameDay(_ aDate: Date) -> Bool
    {
        let components1 = Date.dateComponents(from: self)
        let components2 = Date.dateComponents(from: aDate)
        
        return ((components1.year == components2.year) &&
                (components1.month == components2.month) &&
                (components1.day == components2.day))
    }
    
    
    /// 是相同的一周吗？
    func isSameWeek(_ aDate: Date) -> Bool
    {
        let components1 = Date.dateComponents(from: self)
        let components2 = Date.dateComponents(from: aDate)
        
        // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
        if components1.weekOfYear != components2.weekOfYear {
            return false
        }
        // Must have a time interval under 1 week. Thanks @aclark
        return fabs(self.timeIntervalSince(aDate)) < D_WEEK
    }
    
    /// 是相同的一月吗？
    func isSameMonth(_ aDate: Date) -> Bool
    {
        let components1 = Date.dateComponents(from: self)
        let components2 = Date.dateComponents(from: aDate)
        
        return ((components1.year == components2.year) &&
                (components1.month == components2.month))
    }
    
    /// 是相同的一年吗？
    func isSameYear(_ aDate: Date) -> Bool
    {
        let components1 = Date.dateComponents(from: self)
        let components2 = Date.dateComponents(from: aDate)
        
        return (components1.year == components2.year)
    }
    
    
    
    /// 在当前时间上加上...
    /// - Parameters:
    ///   - aDays: 天
    ///   - aHours: 小时
    ///   - aMinutes: 分
    func dateByAdding(aDays: Double = 0, aHours: Double = 0, aMinutes: Double = 0) -> Date
    {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + D_DAY * aDays
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    /// 在当前时间上减...
    /// - Parameters:
    ///   - aDays: 天
    ///   - aHours: 小时
    ///   - aMinutes: 分
    func dateBySubtracting(aDays: Double = 0, aHours: Double = 0, aMinutes: Double = 0) -> Date
    {
        return self.dateByAdding(aDays: -1 * aDays, aHours: -1 * aHours, aMinutes: -1 * aMinutes)
    }
    
    
    /// 在当前时间上加上...
    /// - Parameters:
    ///   - aDays: 天
    ///   - aHours: 小时
    ///   - aMinutes: 分
    static func dateWithFromNow(aDays: Double = 0, aHours: Double = 0, aMinutes: Double = 0) -> Date
    {
        return Date.init().dateByAdding(aDays: aDays, aHours: aHours, aMinutes: aMinutes)
    }
    
    /// 在当前时间上减...
    /// - Parameters:
    ///   - aDays: 天
    ///   - aHours: 小时
    ///   - aMinutes: 分
    static func dateWithBeforeNow(aDays: Double = 0, aHours: Double = 0, aMinutes: Double = 0) -> Date
    {
        return self.dateWithFromNow(aDays: -1 * aDays, aHours: -1 * aHours, aMinutes: -1 * aMinutes)
    }
}

extension String
{
    static func string(date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let string = formatter.string(from: date)
        return string
    }
}
