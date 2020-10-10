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

    init(date: Date,
         glass0: Bool = false,
         glass1: Bool = false,
         glass2: Bool = false,
         glass3: Bool = false,
         glass4: Bool = false,
         glass5: Bool = false,
         glass6: Bool = false,
         glass7: Bool = false) {
        self.date = date
        self.glass0 = glass0
        self.glass1 = glass1
        self.glass2 = glass2
        self.glass3 = glass3
        self.glass4 = glass4
        self.glass5 = glass5
        self.glass6 = glass6
        self.glass7 = glass7
    }
}
