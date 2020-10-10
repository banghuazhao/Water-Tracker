//
//  Constants.swift
//  Weather Tracker
//
//  Created by Banghua Zhao on 7/6/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

struct Constants {
    static let appID = "1534891702"

    // google ads app id: ca-app-pub-4766086782456413~8934464979
    #if DEBUG
        static let bannerViewAdUnitID = ""
//    static let interstitialAdID = ""

//        static let bannerViewAdUnitID = "ca-app-pub-3940256099942544/2934735716"
        static let rewardAdUnitID = "ca-app-pub-3940256099942544/1712485313"
        static let interstitialAdID = "ca-app-pub-3940256099942544/1033173712"

    #else
        static let bannerViewAdUnitID = "ca-app-pub-4766086782456413/6938539797"
        static let interstitialAdID = "ca-app-pub-4766086782456413/7289893587"
        static let rewardAdUnitID = "ca-app-pub-4766086782456413/8411403567"
        static let appOpenAdUnitID = "ca-app-pub-4766086782456413/5593668532"
    #endif
}

struct UserDefaultsKeys {
    static let FETCH_COUNT = "FETCH_COUNT"
    static let REMINDER_INDEX = "REMINDER_INDEX"
}

let categoryExpenses: [String] = [
    "Grocery",
    "Transportation",
    "Entertainment",
    "Restaurant",
    "House Rent",
    "Insurance",
    "Travel",
    "Education",
    "Consumer Electronics",
    "Gift",
    "Medicine",
    "Other Expense",
]
let categoryIncomes: [String] = [
    "Salary",
    "Investment Income",
    "Other Income",
]
