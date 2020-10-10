//
//  ReminderCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    lazy var bellView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "bell.fill")
        imageView.tintColor = .darkGray
    }

    lazy var reminderLabel = UILabel().then { label in
        label.text = "Reminder".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
    }

    lazy var reminderValueButton = UIButton().then { button in
        button.setTitleColor(.themeColor, for: .normal)
        let title: String
        if let index = UserDefaults.standard.value(forKey: UserDefaultsKeys.REMINDER_INDEX) as? Int {
            if index == 0 {
                title = "After 1 hour".localized()
            } else if index == 1 {
                title = "After 2 hours".localized()
            } else if index == 2 {
                title = "After 3 hours".localized()
            } else {
                title = "No Reminder".localized()
            }
        } else {
            title = "After 1 hour".localized()
        }
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }

    lazy var arrowImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .themeColor
        imageView.contentMode = .scaleAspectFit
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        selectionStyle = .none
        contentView.addSubview(bellView)
        contentView.addSubview(reminderLabel)
        contentView.addSubview(reminderValueButton)
        contentView.addSubview(arrowImageView)

        bellView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(25)
        }

        reminderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(bellView.snp.right).offset(10)
        }

        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(15)
        }

        reminderValueButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(124)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
