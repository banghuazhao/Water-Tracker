//
//  AppDelegate.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/7/20.
//

import CoreData
#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Localize_Swift
import SnapKit
import SwiftDate
import Then
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let notificationHandler = NotificationHandler()

    #if !targetEnvironment(macCatalyst)
        var appOpenAd: GADAppOpenAd?
        var loadTime: Date = Date()
    #endif

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        #if !targetEnvironment(macCatalyst)
            requestATTPermission()
            GADMobileAds.sharedInstance().start(completionHandler: nil)

        #else
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1000, height: 800)
            }
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1000, height: 800)
            }
        #endif

        UNUserNotificationCenter.current().delegate = notificationHandler

        StoreReviewHelper.incrementFetchCount()
        StoreReviewHelper.checkAndAskForReview()

        setupDefaultWaterRecord()
        setupDefaultReminderTime()

        ReminderTimeStore.shared.fetchAllFromLocal()

        let navigationController = MyNavigationController(rootViewController: HomeViewController())
        navigationController.setBackground(color: .systemBackground)
        navigationController.setTintColor(color: .themeColor)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        #if !targetEnvironment(macCatalyst)
            tryToPresentAd()
        #endif
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

#if targetEnvironment(macCatalyst)
    extension AppDelegate {
        override func buildMenu(with builder: UIMenuBuilder) {
            super.buildMenu(with: builder)
            builder.remove(menu: .help)
            builder.remove(menu: .format)
        }
    }
#endif

#if !targetEnvironment(macCatalyst)

    // MARK: - App open ad related

    extension AppDelegate: GADFullScreenContentDelegate {
        func requestAppOpenAd() {
            appOpenAd = nil
            GADAppOpenAd.load(
                withAdUnitID: Constants.appOpenAdUnitID,
                request: GADRequest(),
                orientation: .portrait) { appOpenAd, error in
                if error != nil {
                    print("Failed to load app open ad: \(String(describing: error))")
                }
                self.appOpenAd = appOpenAd
                self.appOpenAd?.fullScreenContentDelegate = self
                self.loadTime = Date()
            }
        }

        func tryToPresentAd() {
            let ad = appOpenAd
            appOpenAd = nil
            if ad != nil && wasLoadTimeLessThanNHoursAgo(n: 4) {
                if let rootViewController = window?.rootViewController {
                    ad?.present(fromRootViewController: rootViewController)
                }
            } else {
                requestAppOpenAd()
            }
        }

        func wasLoadTimeLessThanNHoursAgo(n: Int) -> Bool {
            let now = Date()
            let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(loadTime)
            let secondsPerHour = 3600.0
            let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
            return intervalInHours < Double(n)
        }

        func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            print("didFailToPresentFullSCreenCContentWithError")
            requestAppOpenAd()
        }

        func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print("adDidPresentFullScreenContent")
        }

        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print("adDidDismissFullScreenContent")
            requestAppOpenAd()
        }
    }
#endif

// MARK: - other functions

extension AppDelegate {
    func setupDefaultWaterRecord() {
        let defaultValues = ["firstRun": true]
        UserDefaults.standard.register(defaults: defaultValues)

        guard UserDefaults.standard.bool(forKey: "firstRun") else { return }

        let context = CoreDataManager.shared.persistentContainer.viewContext

        let userWaterRecords = [
            UserWaterRecord(date: Date() - 1.days,
                            glass0: true, glass2: true, glass5: true, glass6: true,
                            glass0Date: DateComponents(calendar: Calendar.current, hour: 9, minute: 0).date,
                            glass2Date: DateComponents(calendar: Calendar.current, hour: 11, minute: 30).date,
                            glass5Date: DateComponents(calendar: Calendar.current, hour: 14, minute: 30).date,
                            glass6Date: DateComponents(calendar: Calendar.current, hour: 16, minute: 0).date
            ),
            UserWaterRecord(date: Date() - 3.days,
                            glass0: true, glass1: true, glass2: true, glass3: true, glass4: true, glass5: true, glass6: true, glass7: true,
                            glass0Date: DateComponents(calendar: Calendar.current, hour: 9, minute: 0).date,
                            glass1Date: DateComponents(calendar: Calendar.current, hour: 10, minute: 30).date,
                            glass2Date: DateComponents(calendar: Calendar.current, hour: 13, minute: 30).date,
                            glass3Date: DateComponents(calendar: Calendar.current, hour: 15, minute: 0).date,
                            glass4Date: DateComponents(calendar: Calendar.current, hour: 16, minute: 0).date,
                            glass5Date: DateComponents(calendar: Calendar.current, hour: 17, minute: 30).date,
                            glass6Date: DateComponents(calendar: Calendar.current, hour: 19, minute: 0).date,
                            glass7Date: DateComponents(calendar: Calendar.current, hour: 20, minute: 30).date

            ),
            UserWaterRecord(date: Date() - 8.days,
                            glass0: true, glass1: true, glass2: true, glass3: true, glass4: true, glass5: true, glass6: true, glass7: true,
                            glass0Date: DateComponents(calendar: Calendar.current, hour: 9, minute: 20).date,
                            glass1Date: DateComponents(calendar: Calendar.current, hour: 10, minute: 10).date,
                            glass2Date: DateComponents(calendar: Calendar.current, hour: 13, minute: 30).date,
                            glass3Date: DateComponents(calendar: Calendar.current, hour: 15, minute: 20).date,
                            glass4Date: DateComponents(calendar: Calendar.current, hour: 16, minute: 10).date,
                            glass5Date: DateComponents(calendar: Calendar.current, hour: 17, minute: 20).date,
                            glass6Date: DateComponents(calendar: Calendar.current, hour: 19, minute: 10).date,
                            glass7Date: DateComponents(calendar: Calendar.current, hour: 20, minute: 0).date
            ),
            UserWaterRecord(date: Date() - 1.months - 2.days,
                            glass1: true, glass2: true, glass3: true, glass5: true, glass7: true,
                            glass1Date: DateComponents(calendar: Calendar.current, hour: 9, minute: 10).date,
                            glass2Date: DateComponents(calendar: Calendar.current, hour: 14, minute: 0).date,
                            glass3Date: DateComponents(calendar: Calendar.current, hour: 16, minute: 20).date,
                            glass5Date: DateComponents(calendar: Calendar.current, hour: 17, minute: 20).date,
                            glass7Date: DateComponents(calendar: Calendar.current, hour: 20, minute: 0).date

            ),
        ]

        for userWaterRecord in userWaterRecords {
            let waterRecord = NSEntityDescription.insertNewObject(forEntityName: "WaterRecord", into: context) as! WaterRecord

            waterRecord.setValue(userWaterRecord.date, forKey: "date")
            waterRecord.setValue(userWaterRecord.glass0, forKey: "glass0")
            waterRecord.setValue(userWaterRecord.glass1, forKey: "glass1")
            waterRecord.setValue(userWaterRecord.glass2, forKey: "glass2")
            waterRecord.setValue(userWaterRecord.glass3, forKey: "glass3")
            waterRecord.setValue(userWaterRecord.glass4, forKey: "glass4")
            waterRecord.setValue(userWaterRecord.glass5, forKey: "glass5")
            waterRecord.setValue(userWaterRecord.glass6, forKey: "glass6")
            waterRecord.setValue(userWaterRecord.glass7, forKey: "glass7")
            waterRecord.setValue(userWaterRecord.glass0Date, forKey: "glass0Date")
            waterRecord.setValue(userWaterRecord.glass1Date, forKey: "glass1Date")
            waterRecord.setValue(userWaterRecord.glass2Date, forKey: "glass2Date")
            waterRecord.setValue(userWaterRecord.glass3Date, forKey: "glass3Date")
            waterRecord.setValue(userWaterRecord.glass4Date, forKey: "glass4Date")
            waterRecord.setValue(userWaterRecord.glass5Date, forKey: "glass5Date")
            waterRecord.setValue(userWaterRecord.glass6Date, forKey: "glass6Date")
            waterRecord.setValue(userWaterRecord.glass7Date, forKey: "glass7Date")
        }

        // perform the save
        do {
            try context.save()

            // success
            UserDefaults.standard.set(false, forKey: "firstRun")
        } catch let saveErr {
            print("Failed to save user transactions:", saveErr)
        }
    }

    func setupDefaultReminderTime() {
        guard UserDefaults.standard.value(forKey: "firstReminderTimeRun") == nil else { return }

        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        let context = CoreDataManager.shared.persistentContainer.viewContext

        let dates = [
            Date.createDate(year: 2021, month: 1, day: 1, hour: 9, minute: 0, second: 0),
            Date.createDate(year: 2021, month: 1, day: 1, hour: 10, minute: 30, second: 0),
            Date.createDate(year: 2021, month: 1, day: 1, hour: 13, minute: 0, second: 0),
            Date.createDate(year: 2021, month: 1, day: 1, hour: 14, minute: 30, second: 0),
            Date.createDate(year: 2021, month: 1, day: 1, hour: 16, minute: 0, second: 0),
            Date.createDate(year: 2021, month: 1, day: 1, hour: 17, minute: 30, second: 0),
            Date.createDate(year: 2021, month: 1, day: 1, hour: 19, minute: 0, second: 0),
            Date.createDate(year: 2021, month: 1, day: 1, hour: 20, minute: 30, second: 0),
        ]

        for i in 0 ... dates.count - 1 {
            let reminderTime = NSEntityDescription.insertNewObject(forEntityName: "ReminderTime", into: context) as! ReminderTime

            let uuid = UUID()
            reminderTime.setValue(uuid, forKey: "id")
            reminderTime.setValue(dates[i], forKey: "time")

            context.insert(reminderTime)

            UserNotificationManager.shared.schedule(id: uuid, title: "\("Time to drink water".localized()) 🥤", subTitle: nil, body: nil, badges: 1, isRepeat: true, dateComponents: DateComponents(calendar: Calendar.current, hour: dates[i]?.hour, minute: dates[i]?.minute))
        }
        // perform the save
        do {
            try context.save()

            UserNotificationManager.shared.listScheduledNotifications()

            // success
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.firstReminderTimeRun)
        } catch let saveErr {
            print("Failed to save user events item:", saveErr)
        }
    }
}
