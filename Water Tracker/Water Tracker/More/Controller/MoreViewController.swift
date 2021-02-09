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

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
    import Toast_Swift
#endif

class MoreViewController: UIViewController, MFMailComposeViewControllerDelegate {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()

        var userDidEarn = false

        var rewardedAd: GADRewardedAd?

    #endif

    #if !targetEnvironment(macCatalyst)
        let moreItems = [
            MoreItem(title: "Feedback".localized(), icon: UIImage(named: "icon_feedback")),
            MoreItem(title: "Rate this App".localized(), icon: UIImage(named: "icon_rateStar")),
            MoreItem(title: "Share this App".localized(), icon: UIImage(named: "icon_share")),
            MoreItem(title: "Support this App".localized(), icon: UIImage(named: "icon_smile")),
            MoreItem(title: "More Apps".localized(), icon: UIImage(named: "icon_more")),
        ]
    #else
        let moreItems = [
            MoreItem(title: "Feedback".localized(), icon: UIImage(named: "icon_feedback")),
            MoreItem(title: "Rate this App".localized(), icon: UIImage(named: "icon_rateStar")),
            MoreItem(title: "Share this App".localized(), icon: UIImage(named: "icon_share")),
            MoreItem(title: "More Apps".localized(), icon: UIImage(named: "icon_more")),
        ]
    #endif

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(MoreCell.self, forCellReuseIdentifier: "MoreCell")
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.separatorColor = UIColor.label
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "More".localized()
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

    #if !targetEnvironment(macCatalyst)
        override func viewWillAppear(_ animated: Bool) {
            GADRewardedAd.load(withAdUnitID: Constants.rewardAdUnitID, request: GADRequest()) { ad, error in
                if let error = error {
                    print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                    return
                }
                self.rewardedAd = ad
                self.rewardedAd?.fullScreenContentDelegate = self
            }
        }

    #endif
}

extension MoreViewController {
    @objc func backToHome() {
        dismiss(animated: true, completion: nil)
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreItems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell

        cell.moreItem = moreItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(FeedbackViewController(), animated: true)
        }

        if indexPath.row == 1 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            if let reviewURL = URL(string: "https://itunes.apple.com/app/id\(Constants.appID)?action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
                UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
            }
        }

        if indexPath.row == 2 {
            let textToShare = "Water Tracker".localized()

            let image = UIImage(named: "app_icon_180")!

            if let myWebsite = URL(string: "http://itunes.apple.com/app/id\(Constants.appID)") {
                // Enter link to your app here
                let objectsToShare = [textToShare, myWebsite, image] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                if let popoverController = activityVC.popoverPresentationController {
                    popoverController.sourceRect = tableView.cellForRow(at: indexPath)?.bounds ?? .zero
                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                }
                present(activityVC, animated: true, completion: nil)
            }
        }

        #if !targetEnvironment(macCatalyst)
            if indexPath.row == 3 {
                tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
                let alterController = UIAlertController(title: "Support this App".localized(), message: "\("Do you want to watch an advertisement to support this App".localized())?", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Yes".localized(), style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    if let ad = self.rewardedAd {
                        ad.present(fromRootViewController: self, userDidEarnRewardHandler: {
                            self.userDidEarn = true
                        })
                    } else {
                        self.view.makeToast("The Ads wasn't ready. Please try later.".localized(), duration: 2.0)
                        print("RewardedAd wasn't ready")
                    }
                }
                let action2 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                alterController.addAction(action1)
                alterController.addAction(action2)
                present(alterController, animated: true)
            }
            if indexPath.row == 4 {
                navigationController?.pushViewController(MoreAppsViewController(), animated: true)
            }
        #else
            if indexPath.row == 3 {
                navigationController?.pushViewController(MoreAppsViewController(), animated: true)
            }
        #endif
    }
}

#if !targetEnvironment(macCatalyst)
    extension MoreViewController: GADFullScreenContentDelegate {
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print(#function)
            if userDidEarn {
                let ac = UIAlertController(title: "\("Thanks for Your Support".localized())!", message: "\("We will constantly optimize and maintain our App and make sure users have the best experience".localized()).", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                ac.addAction(action1)
                present(ac, animated: true)
            }
            userDidEarn = false
        }
    }

#endif
