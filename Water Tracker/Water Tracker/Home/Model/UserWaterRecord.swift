//
//  UserWaterRecord.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/8/20.
//

import Foundation

class UserWaterRecord {
    let date: Date
    let glass0: Bool
    let glass1: Bool
    let glass2: Bool
    let glass3: Bool
    let glass4: Bool
    let glass5: Bool
    let glass6: Bool
    let glass7: Bool
    var glass0Date: Date?
    var glass1Date: Date?
    var glass2Date: Date?
    var glass3Date: Date?
    var glass4Date: Date?
    var glass5Date: Date?
    var glass6Date: Date?
    var glass7Date: Date?

    init(date: Date,
         glass0: Bool = false,
         glass1: Bool = false,
         glass2: Bool = false,
         glass3: Bool = false,
         glass4: Bool = false,
         glass5: Bool = false,
         glass6: Bool = false,
         glass7: Bool = false,
         glass0Date: Date? = nil,
         glass1Date: Date? = nil,
         glass2Date: Date? = nil,
         glass3Date: Date? = nil,
         glass4Date: Date? = nil,
         glass5Date: Date? = nil,
         glass6Date: Date? = nil,
         glass7Date: Date? = nil
    ) {
        self.date = date
        self.glass0 = glass0
        self.glass1 = glass1
        self.glass2 = glass2
        self.glass3 = glass3
        self.glass4 = glass4
        self.glass5 = glass5
        self.glass6 = glass6
        self.glass7 = glass7
        self.glass0Date = glass0Date
        self.glass1Date = glass1Date
        self.glass2Date = glass2Date
        self.glass3Date = glass3Date
        self.glass4Date = glass4Date
        self.glass5Date = glass5Date
        self.glass6Date = glass6Date
        self.glass7Date = glass7Date
    }
}
