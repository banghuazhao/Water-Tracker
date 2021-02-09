//
//  ReminderCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import CoreData
import DatePickerDialog
import Toast_Swift
import UIKit

protocol ReminderCellDelegate: AnyObject {
    func makeReminderTimeExistToast()
}

class ReminderCell: UITableViewCell {
    weak var delegate: ReminderCellDelegate?

    var pickedTime = Date()

    lazy var bellView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "bell.fill")
        imageView.tintColor = .darkGray
    }

    lazy var reminderLabel = UILabel().then { label in
        label.text = "Reminder".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ReminderTimeCell.self, forCellWithReuseIdentifier: "ReminderTimeCell")
        collectionView.register(ReminderAddCell.self, forCellWithReuseIdentifier: "ReminderAddCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        selectionStyle = .none
        contentView.addSubview(bellView)
        contentView.addSubview(reminderLabel)
        contentView.addSubview(collectionView)

        bellView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(25)
        }

        reminderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bellView)
            make.left.equalTo(bellView.snp.right).offset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(bellView.snp.bottom).offset(15)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-15)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ReminderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReminderTimeStore.shared.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReminderAddCell", for: indexPath) as! ReminderAddCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReminderTimeCell", for: indexPath) as! ReminderTimeCell
            cell.reminderTime = ReminderTimeStore.shared.item(at: indexPath.row - 1)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let alert = UIAlertController(style: .actionSheet, source: collectionView.cellForItem(at: indexPath), title: "Add a reminder".localized(), message: nil, tintColor: UIColor.themeColor)
            pickedTime = Date()
            alert.addDatePicker(mode: .time, date: pickedTime) { date in
                self.pickedTime = date
            }
            alert.addAction(title: "Add".localized(), style: .default) { [weak self] _ in
                guard let self = self else { return }
                if ReminderTimeStore.shared.hasTime(for: self.pickedTime) {
                    self.delegate?.makeReminderTimeExistToast()
                } else {
                    let context = CoreDataManager.shared.persistentContainer.viewContext
                    let reminderTime = NSEntityDescription.insertNewObject(forEntityName: "ReminderTime", into: context) as! ReminderTime
                    reminderTime.id = UUID()
                    reminderTime.time = self.pickedTime
                    UserNotificationManager.shared.schedule(id: reminderTime.id!, title: "\("Time to drink water".localized()) 🥤", subTitle: nil, body: nil, badges: 1, isRepeat: true, dateComponents: DateComponents(calendar: Calendar.current, hour: self.pickedTime.hour, minute: self.pickedTime.minute))
                    ReminderTimeStore.shared.add(item: reminderTime)
                    self.collectionView.reloadData()
                }
            }
            alert.addAction(title: "Cancel".localized(), style: .cancel)
            alert.show()
        } else {
            let originalReminderTime = ReminderTimeStore.shared.item(at: indexPath.row - 1)
            let newReminderTime = ReminderTimeStore.shared.item(at: indexPath.row - 1)

            pickedTime = originalReminderTime.time!
            let alert = UIAlertController(style: .actionSheet, source: collectionView.cellForItem(at: indexPath), title: "Edit a reminder".localized(), message: nil, tintColor: UIColor.themeColor)
            alert.addDatePicker(mode: .time, date: pickedTime) { date in
                self.pickedTime = date
            }
            alert.addAction(title: "Edit".localized(), style: .default) { [weak self] _ in
                guard let self = self else { return }
                if originalReminderTime.time != self.pickedTime && ReminderTimeStore.shared.hasTime(for: self.pickedTime) {
                    self.delegate?.makeReminderTimeExistToast()
                } else {
                    newReminderTime.time = self.pickedTime
                    ReminderTimeStore.shared.edit(original: originalReminderTime, new: newReminderTime)
                    UserNotificationManager.shared.schedule(id: newReminderTime.id!, title: "\("Time to drink water".localized()) 🥤", subTitle: nil, body: nil, badges: 1, isRepeat: true, dateComponents: DateComponents(calendar: Calendar.current, hour: self.pickedTime.hour, minute: self.pickedTime.minute))
                    self.collectionView.reloadData()
                }
            }
            alert.addAction(title: "Delete".localized(), style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                UserNotificationManager.shared.remove(id: originalReminderTime.id!)
                ReminderTimeStore.shared.remove(item: originalReminderTime)
                self.collectionView.reloadData()
            }
            alert.addAction(title: "Cancel".localized(), style: .cancel)
            alert.show()
        }
        UserNotificationManager.shared.listScheduledNotifications()
    }
}
