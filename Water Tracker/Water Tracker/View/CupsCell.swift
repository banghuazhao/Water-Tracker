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
    var isDranks: [Bool] = Array(repeating: false, count: 8)

    var waterRecord: WaterRecord? {
        didSet {
            guard let waterRecord = waterRecord else {
                return
            }
            isDranks[0] = waterRecord.glass0
            isDranks[1] = waterRecord.glass1
            isDranks[2] = waterRecord.glass2
            isDranks[3] = waterRecord.glass3
            isDranks[4] = waterRecord.glass4
            isDranks[5] = waterRecord.glass5
            isDranks[6] = waterRecord.glass6
            isDranks[7] = waterRecord.glass7
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
        cell.isDrank = isDranks[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        switch indexPath.row {
        case 0:
            if waterRecord?.glass0 == false {
                waterRecord?.glass0 = true
                isDranks[0] = true
                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                delegate?.didSelectCup()
            }

        case 1:
            if waterRecord?.glass1 == false {
                waterRecord?.glass1 = true
                isDranks[1] = true
                collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
                delegate?.didSelectCup()
            }

        case 2:
            if waterRecord?.glass2 == false {
                waterRecord?.glass2 = true
                isDranks[2] = true
                collectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
                delegate?.didSelectCup()
            }

        case 3:
            if waterRecord?.glass3 == false {
                waterRecord?.glass3 = true
                isDranks[3] = true
                collectionView.reloadItems(at: [IndexPath(item: 3, section: 0)])
                delegate?.didSelectCup()
            }

        case 4:
            if waterRecord?.glass4 == false {
                waterRecord?.glass4 = true
                isDranks[4] = true
                collectionView.reloadItems(at: [IndexPath(item: 4, section: 0)])
                delegate?.didSelectCup()
            }

        case 5:
            if waterRecord?.glass5 == false {
                waterRecord?.glass5 = true
                isDranks[5] = true
                collectionView.reloadItems(at: [IndexPath(item: 5, section: 0)])
                delegate?.didSelectCup()
            }

        case 6:
            if waterRecord?.glass6 == false {
                waterRecord?.glass6 = true
                isDranks[6] = true
                collectionView.reloadItems(at: [IndexPath(item: 6, section: 0)])
                delegate?.didSelectCup()
            }

        case 7:
            if waterRecord?.glass7 == false {
                waterRecord?.glass7 = true
                isDranks[7] = true
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
        let width = (collectionView.frame.size.width - 75) / 4
        return CGSize(width: width, height: 95)
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
