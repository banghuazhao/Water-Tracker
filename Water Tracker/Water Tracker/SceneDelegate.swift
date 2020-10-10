//
//  SceneDelegate.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/7/20.
//

import CoreData
import GoogleMobileAds
import Localize_Swift
import SnapKit
import SwiftDate
import Then
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        (UIApplication.shared.delegate as? AppDelegate)?.window = window

        GADMobileAds.sharedInstance().start(completionHandler: nil)

        StoreReviewHelper.incrementFetchCount()
        StoreReviewHelper.checkAndAskForReview()

        setupDefaultWaterRecord()

        let navigationController = MyNavigationController(rootViewController: HomeViewController())
        navigationController.setBackground(color: .systemBackground)
        navigationController.setTintColor(color: .themeColor)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: - other functions

extension SceneDelegate {
    func setupDefaultWaterRecord() {
        let defaultValues = ["firstRun": true]
        UserDefaults.standard.register(defaults: defaultValues)

        guard UserDefaults.standard.bool(forKey: "firstRun") else { return }

        UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.REMINDER_INDEX)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                let content = UNMutableNotificationContent()
                let eventName = "Drink Water"

                content.title = "Drink Water".localized()
                content.sound = .default
                content.body = "\("Time to drink water".localized()) 🥤"

                let targetDate = Date().addingTimeInterval(60 * 60)

                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: Calendar.current.dateComponents(
                        [.day, .hour, .minute, .second],
                        from: targetDate),
                    repeats: false)

                let request = UNNotificationRequest(identifier: eventName, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })

            } else if error != nil {
                print("error occurred")
            }
        })

        let context = CoreDataManager.shared.persistentContainer.viewContext

        let userWaterRecords = [
            UserWaterRecord(date: Date() - 1.days, glass0: true, glass2: true, glass5: true, glass6: true),
            UserWaterRecord(date: Date() - 3.days, glass0: true, glass1: true, glass2: true, glass3: true, glass4: true, glass5: true, glass6: true, glass7: true),
            UserWaterRecord(date: Date() - 8.days, glass0: true, glass1: true, glass2: true, glass3: true, glass4: true, glass5: true, glass6: true, glass7: true),
            UserWaterRecord(date: Date() - 1.months - 2.days, glass1: true, glass2: true, glass3: true, glass5: true, glass7: true),
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
}
