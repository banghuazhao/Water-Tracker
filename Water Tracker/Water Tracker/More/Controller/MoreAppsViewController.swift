//
//  MoreAppsViewController.swift
//  Apps Bay
//
//  Created by Banghua Zhao on 1/1/21.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import UIKit

class MoreAppsViewController: UIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()

        let appItems = [
            AppItem(
                title: "Countdown Days".localized(),
                detail: "Events, Anniversary & Big Days".localized(),
                icon: UIImage(named: "appIcon_countdownDays"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.countdownDaysAppID)")),
            AppItem(
                title: "Finance Go".localized(),
                detail: "Financial Reports & Investing".localized(),
                icon: UIImage(named: "appIcon_financeGo"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.financeGoAppID)")),
            AppItem(
                title: "Financial Ratios Go".localized(),
                detail: "Finance, Ratios, Investing".localized(),
                icon: UIImage(named: "appIcon_financialRatiosGo"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.financialRatiosGoAppID)")),
            AppItem(
                title: "Money Tracker".localized(),
                detail: "Budget, Expense & Bill Planner".localized(),
                icon: UIImage(named: "appIcon_moneyTracker"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.moneyTrackerAppID)")),
            AppItem(
                title: "Novels Hub".localized(),
                detail: "Fiction eBooks Library!".localized(),
                icon: UIImage(named: "appIcon_novelsHub"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.novelsHubAppID)")),
            AppItem(
                title: "More Apps".localized(),
                detail: "Check out more Apps made by us".localized(),
                icon: UIImage(named: "appIcon_appStore"),
                url: URL(string: "https://apps.apple.com/developer/banghua-zhao/id1288052561#see-all")),
        ]
    #else
        let appItems = [
            AppItem(
                title: "Countdown Days".localized(),
                detail: "Events, Anniversary & Big Days".localized(),
                icon: UIImage(named: "appIcon_countdownDays"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.countdownDaysAppID)")),
            AppItem(
                title: "Finance Go".localized(),
                detail: "Financial Reports & Investing".localized(),
                icon: UIImage(named: "appIcon_financeGo"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.financeGoAppID)")),
            AppItem(
                title: "Ratios Go".localized(),
                detail: "Finance, Ratios, Investing".localized(),
                icon: UIImage(named: "appIcon_financialRatiosGo"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.finanicalRatiosGoMacOSAppID)")),
            AppItem(
                title: "Money Tracker".localized(),
                detail: "Budget, Expense & Bill Planner".localized(),
                icon: UIImage(named: "appIcon_moneyTracker"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.moneyTrackerAppID)")),
            AppItem(
                title: "Novels Hub".localized(),
                detail: "Fiction eBooks Library!".localized(),
                icon: UIImage(named: "appIcon_novelsHub"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.novelsHubAppID)")),
            AppItem(
                title: "More Apps".localized(),
                detail: "Check out more Apps made by us".localized(),
                icon: UIImage(named: "appIcon_appStore"),
                url: URL(string: "https://apps.apple.com/developer/banghua-zhao/id1288052561#see-all")),
        ]
    #endif

    #if !targetEnvironment(macCatalyst)
        lazy var tableView = UITableView().then { tv in
            tv.backgroundColor = .clear
            tv.delegate = self
            tv.dataSource = self
            tv.register(AppItemCell.self, forCellReuseIdentifier: "AppItemCell")
            tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            tv.separatorColor = UIColor.label
            tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        }
    #else
        lazy var tableView = UITableView(frame: .zero, style: .grouped).then { tv in
            tv.backgroundColor = .clear
            tv.delegate = self
            tv.dataSource = self
            tv.register(AppItemCell.self, forCellReuseIdentifier: "AppItemCell")
            tv.register(MoreAppsHeaderCell.self, forHeaderFooterViewReuseIdentifier: "MoreAppsHeaderCell")
            tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            tv.separatorColor = UIColor.label
            tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        }

    #endif

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "More Apps".localized()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)

        #if !targetEnvironment(macCatalyst)
            view.addSubview(bannerView)
            bannerView.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
        #endif

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
    }
}

extension MoreAppsViewController {
    @objc func backToHome() {
        dismiss(animated: true, completion: nil)
    }
}

extension MoreAppsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appItems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + 16 + 16
    }

    #if targetEnvironment(macCatalyst)
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MoreAppsHeaderCell") as! MoreAppsHeaderCell
            return header
        }
    #endif

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppItemCell", for: indexPath) as! AppItemCell
        cell.appItem = appItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let appItem = appItems[indexPath.row]
        if let url = appItem.url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
