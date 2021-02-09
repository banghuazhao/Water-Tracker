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
    
    static let facebookPageID = "104357371640600"

    struct AppID {
        static let fourGreatClassicalNovelsAppID = "1526758926"
        static let chineseClassicalLiteratureAppID = "1529766681"
        static let novelsHubAppID = "1528820845"
        static let financeGoAppID = "1519476344"
        static let finanicalRatiosGoMacOSAppID = "1486184864"
        static let financialRatiosGoAppID = "1481582303"
        static let countdownDaysAppID = "1525084657"
        static let moneyTrackerAppID = "1534244892"
    }

    // google ads app id: ca-app-pub-4766086782456413~8934464979
    #if DEBUG

        static let bannerViewAdUnitID = ""
//        static let bannerViewAdUnitID = "ca-app-pub-3940256099942544/2934735716"

        //    static let interstitialAdID = ""
        static let interstitialAdID = "ca-app-pub-3940256099942544/1033173712"
        static let rewardAdUnitID = "ca-app-pub-3940256099942544/1712485313"

        static let appOpenAdUnitID = "ca-app-pub-3940256099942544/5662855259"
    #else
        static let bannerViewAdUnitID = "ca-app-pub-4766086782456413/6938539797"
        static let interstitialAdID = "ca-app-pub-4766086782456413/7289893587"
        static let rewardAdUnitID = "ca-app-pub-4766086782456413/8411403567"
        static let appOpenAdUnitID = "ca-app-pub-4766086782456413/5593668532"

    #endif
}

struct UserDefaultsKeys {
    static let FETCH_COUNT = "FETCH_COUNT"
    static let timesToOpenInterstitialAds = "timesToOpenInterstitialAds"
    static let firstRun = "firstRun"
    static let firstReminderTimeRun = "firstReminderTimeRun"
}
