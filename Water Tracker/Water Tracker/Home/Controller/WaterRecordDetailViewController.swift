//
//  WaterRecordDetailViewController.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 2021/2/5.
//

import CoreData
#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import UIKit

class WaterRecordDetailViewController: UIViewController {
    var todayWaterRecord: WaterRecord?

    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(DrankCell.self, forCellReuseIdentifier: "DrankCell")
        tv.register(CupsCell.self, forCellReuseIdentifier: "CupsCell")

        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupViews()
    }

    private func setupNavigationBar() {
        title = "Water Record".localized()
    }

    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        #if !targetEnvironment(macCatalyst)
            view.addSubview(bannerView)
            bannerView.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(60 + 45 + 190 + 30)
            }
        #endif
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension WaterRecordDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 45 + 95 * 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrankCell") as! DrankCell
            cell.waterRecord = todayWaterRecord
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CupsCell") as! CupsCell
            cell.waterRecord = todayWaterRecord
            cell.collectionView.isUserInteractionEnabled = false
            return cell
        }
    }
}
