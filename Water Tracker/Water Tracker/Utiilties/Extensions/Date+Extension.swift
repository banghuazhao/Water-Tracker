//
//  Date+Extension.swift
//  Countdown Days
//
//  Created by Banghua Zhao on 7/3/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation

extension Date {
    
    var timeString: String {
        let hours = Calendar.current.component(.hour, from: self)
        let minutes = Calendar.current.component(.minute, from: self)
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        return "\(hoursString):\(minutesString)"
    }
    
    var timeOfHourAndMinutes: Int {
        return 60 * Calendar.current.component(.hour, from: self) + Calendar.current.component(.minute, from: self)
    }

    var day: Int {
        return Calendar.current.component(Calendar.Component.day, from: self)
    }

    var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }

    var hour: Int {
        return Calendar.current.component(Calendar.Component.hour, from: self)
    }

    var minute: Int {
        return Calendar.current.component(Calendar.Component.minute, from: self)
    }

    var second: Int {
        return Calendar.current.component(Calendar.Component.second, from: self)
    }

    /// 是否在未来
    var isInFuture: Bool {
        return self > Date()
    }

    /// 是否在过去
    var isInPast: Bool {
        return self < Date()
    }

    /// 是否在本天
    var isInToday: Bool {
        return day == Date().day && month == Date().month && year == Date().year
    }

    var dateFormatString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    static func createDate(year: Int, month: Int, day: Int, hour: Int = Date().hour, minute: Int = Date().minute, second: Int = Date().second) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return Calendar.current.date(from: components)
    }
    
    
}
