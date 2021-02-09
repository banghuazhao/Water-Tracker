//
//  CupsCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

protocol CupsCellDelegate {
    func didSelectCup()
}

class CupsCell: UITableViewCell {
    var delegate: CupsCellDelegate?
    var drankRecords: [DrankRecord] = Array(repeating: DrankRecord(), count: 8)

    var waterRecord: WaterRecord? {
        didSet {
            guard let waterRecord = waterRecord else {
                return
            }

            drankRecords[0].isDrank = waterRecord.glass0
            drankRecords[0].drankTime = waterRecord.glass0Date

            drankRecords[1].isDrank = waterRecord.glass1
            drankRecords[1].drankTime = waterRecord.glass1Date

            drankRecords[2].isDrank = waterRecord.glass2
            drankRecords[2].drankTime = waterRecord.glass2Date

            drankRecords[3].isDrank = waterRecord.glass3
            drankRecords[3].drankTime = waterRecord.glass3Date

            drankRecords[4].isDrank = waterRecord.glass4
            drankRecords[4].drankTime = waterRecord.glass4Date

            drankRecords[5].isDrank = waterRecord.glass5
            drankRecords[5].drankTime = waterRecord.glass5Date

            drankRecords[6].isDrank = waterRecord.glass6
            drankRecords[6].drankTime = waterRecord.glass6Date

            drankRecords[7].isDrank = waterRecord.glass7
            drankRecords[7].drankTime = waterRecord.glass7Date

            collectionView.reloadData()
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(WaterCell.self, forCellWithReuseIdentifier: "WaterCell")
        cv.backgroundColor = .systemBackground
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CupsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterCell", for: indexPath) as! WaterCell
        cell.drankRecord = drankRecords[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        switch indexPath.row {
        case 0:
            if waterRecord?.glass0 == false {
                waterRecord?.glass0 = true
                waterRecord?.glass0Date = Date()
                drankRecords[0].isDrank = true
                drankRecords[0].drankTime = waterRecord?.glass0Date
                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                delegate?.didSelectCup()
            }

        case 1:
            if waterRecord?.glass1 == false {
                waterRecord?.glass1 = true
                waterRecord?.glass1Date = Date()
                drankRecords[1].isDrank = true
                drankRecords[1].drankTime = waterRecord?.glass1Date
                collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
                delegate?.didSelectCup()
            }

        case 2:
            if waterRecord?.glass2 == false {
                waterRecord?.glass2 = true
                waterRecord?.glass2Date = Date()
                drankRecords[2].isDrank = true
                drankRecords[2].drankTime = waterRecord?.glass2Date
                collectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
                delegate?.didSelectCup()
            }

        case 3:
            if waterRecord?.glass3 == false {
                waterRecord?.glass3 = true
                waterRecord?.glass3Date = Date()
                drankRecords[3].isDrank = true
                drankRecords[3].drankTime = waterRecord?.glass3Date
                collectionView.reloadItems(at: [IndexPath(item: 3, section: 0)])
                delegate?.didSelectCup()
            }

        case 4:
            if waterRecord?.glass4 == false {
                waterRecord?.glass4 = true
                waterRecord?.glass4Date = Date()
                drankRecords[4].isDrank = true
                drankRecords[4].drankTime = waterRecord?.glass4Date
                collectionView.reloadItems(at: [IndexPath(item: 4, section: 0)])
                delegate?.didSelectCup()
            }

        case 5:
            if waterRecord?.glass5 == false {
                waterRecord?.glass5 = true
                waterRecord?.glass5Date = Date()
                drankRecords[5].isDrank = true
                drankRecords[5].drankTime = waterRecord?.glass5Date
                collectionView.reloadItems(at: [IndexPath(item: 5, section: 0)])
                delegate?.didSelectCup()
            }

        case 6:
            if waterRecord?.glass6 == false {
                waterRecord?.glass6 = true
                waterRecord?.glass6Date = Date()
                drankRecords[6].isDrank = true
                drankRecords[6].drankTime = waterRecord?.glass6Date
                collectionView.reloadItems(at: [IndexPath(item: 6, section: 0)])
                delegate?.didSelectCup()
            }

        case 7:
            if waterRecord?.glass7 == false {
                waterRecord?.glass7 = true
                waterRecord?.glass7Date = Date()
                drankRecords[7].isDrank = true
                drankRecords[7].drankTime = waterRecord?.glass7Date
                collectionView.reloadItems(at: [IndexPath(item: 7, section: 0)])
                delegate?.didSelectCup()
            }

        default:
            break
        }
        let context = CoreDataManager.shared.persistentContainer.viewContext
        // perform the save
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save user WaterRecord:", saveErr)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

// -------------------------------------------------------------------------------------------------------------------------------------------------
extension CupsCell: UICollectionViewDelegateFlowLayout {
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        #if !targetEnvironment(macCatalyst)
            let width = (collectionView.frame.size.width - 75) / 4
            return CGSize(width: width, height: 95)
        #else
            let width = (1000 - 75) / 4
            return CGSize(width: width, height: 95)
        #endif
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
