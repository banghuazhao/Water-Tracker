//
//  MenuViewController.swift
//  Countdown Days
//
//  Created by Banghua Zhao on 8/1/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

import MessageUI
import SafariServices

import GoogleMobileAds
import SVProgressHUD

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    lazy var bannerView: GADBannerView = {
        let bannerView = GADBannerView()
        bannerView.adUnitID = Constants.bannerViewAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        return bannerView
    }()

    var userDidEarn = false

    var rewardedAd: GADRewardedAd?

    let menuItems = [
        MyMenuItem(title: "Feedback".localized(), icon: UIImage(systemName: "bubble.left")),
        MyMenuItem(title: "Rate the App".localized(), icon: UIImage(systemName: "star")),
        MyMenuItem(title: "Share the App".localized(), icon: UIImage(systemName: "square.and.arrow.up")),
        MyMenuItem(title: "Support the App".localized(), icon: UIImage(systemName: "face.smiling")),
    ]

    lazy var tableView = UITableView().then { tv in
        tv.delegate = self
        tv.dataSource = self
        tv.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Settings".localized()

        view.addSubview(tableView)

        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    deinit {
        print("MenuController deinit")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell

        cell.menuItem = menuItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            guard let url = URL(string: "https://banghuazhao.github.io/Water-Tracker/contact/") else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }

        if indexPath.row == 1 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            StoreReviewHelper().requestReview()
        }

        if indexPath.row == 2 {
            let textToShare = "Water Tracker".localized()

            let image = UIImage(named: "app_icon_180")!

            if let myWebsite = URL(string: "http://itunes.apple.com/app/id\(Constants.appID)") {
                // Enter link to your app here
                let objectsToShare = [textToShare, myWebsite, textToShare, image] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                if let popoverController = activityVC.popoverPresentationController {
                    popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                    popoverController.sourceView = view
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
                present(activityVC, animated: true, completion: nil)
            }
        }

        if indexPath.row == 3 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            let alterController = UIAlertController(title: "Support this App".localized(), message: "Do you want to watch an advertisement to support this App?".localized(), preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes".localized(), style: .default) { [weak self] _ in
                guard let self = self else { return }
                SVProgressHUD.show(withStatus: "Loading the advertisement".localized())
                self.rewardedAd = GADRewardedAd(adUnitID: Constants.rewardAdUnitID)
                self.rewardedAd?.load(GADRequest()) { error in
                    SVProgressHUD.dismiss()
                    if let _ = error {
                    } else {
                        self.rewardedAd?.present(fromRootViewController: self, delegate: self)
                    }
                }
            }
            let action2 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            alterController.addAction(action1)
            alterController.addAction(action2)
            present(alterController, animated: true)
        }
    }
}

extension MenuViewController: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        userDidEarn = true
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        SVProgressHUD.dismiss()
        if userDidEarn {
            let ac = UIAlertController(title: "Thanks for Your Support!".localized(), message: "We will constantly optimize and maintain our App and make sure users have the best experience.".localized(), preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            ac.addAction(action1)
            present(ac, animated: true)
        }
        userDidEarn = false
    }
}
