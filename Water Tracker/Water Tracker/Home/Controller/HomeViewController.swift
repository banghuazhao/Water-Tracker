//
//  HomeViewController.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/7/20.
//

import CoreData
#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Sheeeeeeeeet
import UIKit

class HomeViewController: UIViewController {
    #if !targetEnvironment(macCatalyst)
        var interstitial: GADInterstitialAd?
    #endif

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

        #if !targetEnvironment(macCatalyst)
            GADInterstitialAd.load(withAdUnitID: Constants.interstitialAdID, request: GADRequest()) { ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = ad
            }
        #endif

        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupViews()

        fetchWaterRecords()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print(#function)
//
//    }

    private func setupNavigationBar() {
        title = "Drink Water".localized()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "navItem_more")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(tapMenuButton(_:)))

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "navItem_refresh")?.withRenderingMode(.alwaysTemplate),
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
        navigationController?.pushViewController(MoreViewController(), animated: true)
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
        let waterRecordsViewController = WaterRecordsViewController()
        waterRecordsViewController.delegate = self
        navigationController?.pushViewController(waterRecordsViewController, animated: true)
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
                return 15 + 25 + 15 + 60 + 15
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
                cell.delegate = self
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

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 && indexPath.row != 0 {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized()) { [weak self] _, _, _ in
                guard let self = self else { return }
                // delete the company from Core Data
                let context = CoreDataManager.shared.persistentContainer.viewContext

                let waterRecord = self.waterRecords[indexPath.row - 1]
                self.waterRecords.remove(at: indexPath.row - 1)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                context.delete(waterRecord)

                do {
                    try context.save()
                    self.fetchWaterRecords()
                    self.tableView.reloadData()
                } catch let saveErr {
                    print("Failed to delete company:", saveErr)
                }
            }
            deleteAction.backgroundColor = UIColor.red

            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row != 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let waterRecord = waterRecords[indexPath.row - 1]
            let waterRecordDetailViewController = WaterRecordDetailViewController()
            waterRecordDetailViewController.todayWaterRecord = waterRecord
            navigationController?.pushViewController(waterRecordDetailViewController, animated: true)
        }
    }
}

// MARK: - CupsCellDelegate

extension HomeViewController: CupsCellDelegate {
    func didSelectCup() {
        playBackgroundMusic(filename: "DrinkWater.mp3", repeatForever: false)
        tableView.reloadData()
        #if !targetEnvironment(macCatalyst)
            if InterstitialAdsRequestHelper.increaseRequestAndCheckLoadInterstitialAd() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    if let ad = self.interstitial {
                        ad.present(fromRootViewController: self)
                        InterstitialAdsRequestHelper.resetRequestCount()
                    } else {
                        print("interstitial Ad wasn't ready")
                    }
                    GADInterstitialAd.load(withAdUnitID: Constants.interstitialAdID, request: GADRequest()) { ad, error in
                        if let error = error {
                            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                            return
                        }
                        self.interstitial = ad
                    }
                }
            }
        #endif
    }
}

// MARK: - ReminderCellDelegate

extension HomeViewController: ReminderCellDelegate {
    func makeReminderTimeExistToast() {
        view.makeToast("The reminder exists. No need to add again.".localized(), duration: 2.0)
    }
}

// MARK: - WaterRecordsViewControllerDelegate

extension HomeViewController: WaterRecordsViewControllerDelegate {
    func didDeleteWaterRecord() {
        fetchWaterRecords()
        tableView.reloadData()
    }
}
