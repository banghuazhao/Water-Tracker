//
//  ReminderTimeCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 2021/1/31.
//

import UIKit

class ReminderTimeCell: UICollectionViewCell {
    var reminderTime: ReminderTime? {
        didSet {
            guard let reminderTime = reminderTime else { return }
            timeLabel.text = reminderTime.timeString
        }
    }

    lazy var clockImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .systemGray
    }

    lazy var timeLabel = UILabel().then { label in
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 6

        contentView.addSubview(clockImageView)
        contentView.addSubview(timeLabel)

        clockImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
            make.size.equalTo(28)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
