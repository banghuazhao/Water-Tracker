//
//  HomeViewController.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/7/20.
//

import CoreData
import Sheeeeeeeeet
import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {
    var interstitial = GADInterstitial(adUnitID: Constants.interstitialAdID)
    
    var waterRecords: [WaterRecord] = []
    var todayWaterRecord: WaterRecord?

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(DrankCell.self, forCellReuseIdentifier: "DrankCell")
        tv.register(CupsCell.self, forCellReuseIdentifier: "CupsCell")
        tv.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        tv.register(RecordTitleCell.self, forCellReuseIdentifier: "RecordTitleCell")
        tv.register(RecordCell.self, forCellReuseIdentifier: "RecordCell")
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        interstitial = GADInterstitial(adUnitID: Constants.interstitialAdID)
        interstitial.load(GADRequest())
        addObservers()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        fetchWaterRecords()
    }

    private func setupNavigationBar() {
        title = "Water".localized()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(tapMenuButton(_:)))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(tapResetButton(_:)))
    }

    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func fetchWaterRecords() {
        todayWaterRecord = CoreDataManager.shared.findTodayWaterRecord()
        if todayWaterRecord == nil {
            CoreDataManager.shared.createTodayWaterRecord()
            todayWaterRecord = CoreDataManager.shared.findTodayWaterRecord()
        }
        waterRecords = CoreDataManager.shared.fetchLocalWaterRecords()
        if waterRecords.count > 1 {
            waterRecords.sort { (t1, t2) -> Bool in
                guard let date1 = t1.date, let date2 = t2.date else { return true }
                return date1 > date2
            }
        }
        tableView.reloadData()
    }
}

// MARK: - actions

extension HomeViewController {
    @objc func tapMenuButton(_ sender: UIBarButtonItem) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        navigationController?.pushViewController(MenuViewController(), animated: true)
    }

    @objc func tapResetButton(_ sender: UIBarButtonItem) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        CoreDataManager.shared.refreshTodayWaterRecord()
        tableView.reloadData()
    }

    @objc func tapSeeAllButton(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        navigationController?.pushViewController(WaterRecordsViewController(), animated: true)
    }

    @objc func tapReminderButton(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        let reminderIndex: Int
        if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.REMINDER_INDEX) as? Int {
            reminderIndex = index
        } else {
            reminderIndex = 0
        }

        let itemTitles = [
            "After 1 hour".localized(),
            "After 2 hours".localized(),
            "After 3 hours".localized(),
            "No Reminder".localized(),
        ]
        var items: [MenuItem] = []
        for (i, itemTitle) in itemTitles.enumerated() {
            let item = SingleSelectItem(title: itemTitle, isSelected: i == reminderIndex, image: nil)
            items.append(item)
        }

        let cancelButton = CancelButton(title: "Cancel".localized())
        items.append(cancelButton)
        let menu = Menu(title: "Choose the next drink water reminder".localized(), items: items)

        let sheet = menu.toActionSheet { [weak self] _, item in
            guard let self = self else { return }
            guard itemTitles.contains(item.title)  else { return }
            let title = item.title
            sender.setTitle(title, for: .normal)
            let index: Int
            if title.localized() == "After 1 hour".localized() {
                index = 0
            } else if title.localized() == "After 2 hours".localized() {
                index = 1
            } else if title.localized() == "After 3 hours".localized() {
                index = 2
            } else {
                index = 3
            }
            self.resetDrinkWaterReminder(index: index)
        }

        sheet.present(in: self, from: sender)
    }

    func resetDrinkWaterReminder(index: Int) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if index == 3 {
            UserDefaults.standard.setValue(3, forKey: UserDefaultsKeys.REMINDER_INDEX)
        } else {
            var timeInterval: Double = 60 * 60
            if index == 0 {
//                timeInterval = 5
                timeInterval = 60 * 60
                UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.REMINDER_INDEX)
            } else if index == 1 {
//                timeInterval = 10
                timeInterval = 60 * 60 * 2
                UserDefaults.standard.setValue(1, forKey: UserDefaultsKeys.REMINDER_INDEX)
            } else if index == 2 {
//                timeInterval = 15
                timeInterval = 60 * 60 * 3
                UserDefaults.standard.setValue(2, forKey: UserDefaultsKeys.REMINDER_INDEX)
            }

            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    let content = UNMutableNotificationContent()
                    let eventName = "Drink Water"

                    content.title = "Drink Water".localized()
                    content.sound = .default
                    content.body = "\("Time to drink water".localized()) 🥤"

                    let targetDate = Date().addingTimeInterval(timeInterval)

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
        }
    }
}

// MARK: - tableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1 + waterRecords.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 60
            } else if indexPath.row == 1 {
                return 45 + 95 * 2
            } else {
                return 45
            }
        } else {
            if indexPath.row == 0 {
                return 60
            } else {
                return 45
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DrankCell") as! DrankCell
                cell.waterRecord = todayWaterRecord
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CupsCell") as! CupsCell
                cell.waterRecord = todayWaterRecord
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderCell
                cell.reminderValueButton.addTarget(self, action: #selector(tapReminderButton(_:)), for: .touchUpInside)
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTitleCell") as! RecordTitleCell
                cell.seeAllButton.addTarget(self, action: #selector(tapSeeAllButton(_:)), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell") as! RecordCell
                cell.waterRecord = waterRecords[indexPath.row - 1]
                return cell
            }
        }
    }
}

// MARK: - CupsCellDelegate

extension HomeViewController: CupsCellDelegate {
    func didSelectCup() {
        playBackgroundMusic(filename: "DrinkWater.mp3", repeatForever: false)
        tableView.reloadData()
        let randomNum = Int.random(in: 0 ... 4)
        if randomNum == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                    print("interstitial Ad is ready")
                } else {
                    print("interstitial Ad wasn't ready")
                }
                self.interstitial = GADInterstitial(adUnitID: Constants.interstitialAdID)
                self.interstitial.load(GADRequest())
            }
        }
    }
}

// MARK: - Notifications

extension HomeViewController {
    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.applicationDidBecomeActive()
        }
    }

    func applicationDidBecomeActive() {
        print(#function)
        if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.REMINDER_INDEX) as? Int {
            resetDrinkWaterReminder(index: index)
        } else {
            resetDrinkWaterReminder(index: 0)
        }
    }
}

