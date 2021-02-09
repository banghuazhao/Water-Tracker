//
//  WaterRecordsViewController.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/9/20.
//

import CoreData
#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Sheeeeeeeeet
import SnapKit
import SwiftDate
import UIKit

protocol WaterRecordsViewControllerDelegate: AnyObject {
    func didDeleteWaterRecord()
}

class WaterRecordsViewController: UIViewController {
    weak var delegate: WaterRecordsViewControllerDelegate?

    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var waterRecords: [WaterRecord] = []
    var selectedWaterRecords: [WaterRecord] = []
    var isSearching: Bool = false
    var searchText: String = ""
    var searchedWaterRecords: [WaterRecord] = []
    var sortIndex: Int = 0

    lazy var searchController = UISearchController().then { sc in
        sc.searchBar.delegate = self
        sc.searchBar.placeholder = "Search a date".localized()
        sc.searchBar.searchBarStyle = .minimal
    }

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(RecordCell.self, forCellReuseIdentifier: "RecordCell")
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupNavigationBar()
        setupViews()
        fetchWaterRecords()
    }

    private func setupNavigationBar() {
        title = "Drank Records".localized()
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: "Delete".localized(),
                style: .plain,
                target: self,
                action: #selector(tapDeleteButton(_:))),
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                style: .plain,
                target: self,
                action: #selector(tapSortButton(_:))),
        ]
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        #if !targetEnvironment(macCatalyst)
            view.addSubview(bannerView)
            bannerView.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
        #endif
    }

    private func fetchWaterRecords() {
        waterRecords = CoreDataManager.shared.fetchLocalWaterRecords()
        selectedWaterRecords = waterRecords
        sortTransactions()
    }

    private func sortTransactions() {
        switch sortIndex {
        case 0:
            if waterRecords.count > 1 {
                waterRecords.sort { (t1, t2) -> Bool in
                    guard let date1 = t1.date, let date2 = t2.date else { return true }
                    return date1 > date2
                }
            }
            if selectedWaterRecords.count > 1 {
                selectedWaterRecords.sort { (t1, t2) -> Bool in
                    guard let date1 = t1.date, let date2 = t2.date else { return true }
                    return date1 > date2
                }
            }
            if searchedWaterRecords.count > 1 {
                searchedWaterRecords.sort { (t1, t2) -> Bool in
                    guard let date1 = t1.date, let date2 = t2.date else { return true }
                    return date1 > date2
                }
            }
        case 1:
            if waterRecords.count > 1 {
                waterRecords.sort { (t1, t2) -> Bool in
                    guard let date1 = t1.date, let date2 = t2.date else { return true }
                    return date1 < date2
                }
            }
            if selectedWaterRecords.count > 1 {
                selectedWaterRecords.sort { (t1, t2) -> Bool in
                    guard let date1 = t1.date, let date2 = t2.date else { return true }
                    return date1 < date2
                }
            }
            if searchedWaterRecords.count > 1 {
                searchedWaterRecords.sort { (t1, t2) -> Bool in
                    guard let date1 = t1.date, let date2 = t2.date else { return true }
                    return date1 < date2
                }
            }
        case 2:
            if waterRecords.count > 1 {
                waterRecords.sort { (t1, t2) -> Bool in
                    CoreDataManager.shared.getGlassses(waterRecord: t1) > CoreDataManager.shared.getGlassses(waterRecord: t2)
                }
            }
            if selectedWaterRecords.count > 1 {
                selectedWaterRecords.sort { (t1, t2) -> Bool in
                    CoreDataManager.shared.getGlassses(waterRecord: t1) > CoreDataManager.shared.getGlassses(waterRecord: t2)
                }
            }
            if searchedWaterRecords.count > 1 {
                searchedWaterRecords.sort { (t1, t2) -> Bool in
                    CoreDataManager.shared.getGlassses(waterRecord: t1) > CoreDataManager.shared.getGlassses(waterRecord: t2)
                }
            }
        case 3:
            if waterRecords.count > 1 {
                waterRecords.sort { (t1, t2) -> Bool in
                    CoreDataManager.shared.getGlassses(waterRecord: t1) < CoreDataManager.shared.getGlassses(waterRecord: t2)
                }
            }
            if selectedWaterRecords.count > 1 {
                selectedWaterRecords.sort { (t1, t2) -> Bool in
                    CoreDataManager.shared.getGlassses(waterRecord: t1) < CoreDataManager.shared.getGlassses(waterRecord: t2)
                }
            }
            if searchedWaterRecords.count > 1 {
                searchedWaterRecords.sort { (t1, t2) -> Bool in
                    CoreDataManager.shared.getGlassses(waterRecord: t1) < CoreDataManager.shared.getGlassses(waterRecord: t2)
                }
            }
        default:
            break
        }
    }
}

// MARK: - tableView

extension WaterRecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedWaterRecords.count
        } else {
            return selectedWaterRecords.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell") as! RecordCell
            cell.waterRecord = searchedWaterRecords[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell") as! RecordCell
            cell.waterRecord = selectedWaterRecords[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized()) { [weak self] _, _, _ in
            guard let self = self else { return }
            // delete the company from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext

            if self.isSearching {
                let waterRecord = self.searchedWaterRecords[indexPath.row]
                self.searchedWaterRecords.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                context.delete(waterRecord)
            } else {
                let waterRecord = self.selectedWaterRecords[indexPath.row]
                self.selectedWaterRecords.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                context.delete(waterRecord)
            }

            do {
                try context.save()
                self.fetchWaterRecords()
                self.tableView.reloadData()
                self.delegate?.didDeleteWaterRecord()
            } catch let saveErr {
                print("Failed to delete company:", saveErr)
            }
        }
        deleteAction.backgroundColor = UIColor.red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let waterRecord = waterRecords[indexPath.row]
        let waterRecordDetailViewController = WaterRecordDetailViewController()
        waterRecordDetailViewController.todayWaterRecord = waterRecord
        navigationController?.pushViewController(waterRecordDetailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension WaterRecordsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText != "" {
            searchedWaterRecords = selectedWaterRecords.filter({ (selectedWaterRecord) -> Bool in
                if let dateString = selectedWaterRecord.date?.toFormat("yyyy-MM-dd"),
                   dateString.contains(searchText.lowercased()) {
                    return true
                }
                return false
            })
            isSearching = true
        } else {
            isSearching = false
        }
        tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchText
        if searchBar.text == "" {
            isSearching = false
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchText = ""
        searchBar.text = ""
        tableView.reloadData()
    }
}

// MARK: - actions

extension WaterRecordsViewController {
    @objc func tapSortButton(_ sender: UIBarButtonItem) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let itemTitles = [
            "Date: New to Old".localized(),
            "Date: Old to New".localized(),
            "Glasses: High to Low".localized(),
            "Glasses: Low to High".localized(),
        ]
        var items: [MenuItem] = []
        for (i, itemTitle) in itemTitles.enumerated() {
            let item = SingleSelectItem(title: itemTitle, isSelected: i == sortIndex, image: nil)
            items.append(item)
        }

        let cancelButton = CancelButton(title: "Cancel".localized())
        items.append(cancelButton)
        let menu = Menu(title: "Sort By".localized(), items: items)

        let sheet = menu.toActionSheet { [weak self] _, item in
            guard let self = self else { return }
            guard itemTitles.contains(item.title) else { return }
            let title = item.title
            self.sortIndex = itemTitles.firstIndex(of: title)!
            self.sortTransactions()
            self.tableView.reloadData()
        }

        sheet.present(in: self, from: sender)
    }

    @objc func tapDeleteButton(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItems?[0].title = "Delete".localized()
        } else {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItems?[0].title = "Done".localized()
        }
    }
}
