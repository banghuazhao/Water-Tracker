//
//  ReminderTime+Extension.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 2021/1/31.
//

import Foundation

extension ReminderTime {

    var timeString: String {
        let hours = Calendar.current.component(.hour, from: time!)
        let minutes = Calendar.current.component(.minute, from: time!)
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        return "\(hoursString):\(minutesString)"
    }
}
