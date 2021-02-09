//
//  DrankCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class DrankCell: UITableViewCell {
    
    var waterRecord: WaterRecord? {
        didSet {
            guard let waterRecord = waterRecord else {
                return
            }
            var glasses = 0
            if waterRecord.glass0 { glasses += 1 }
            if waterRecord.glass1 { glasses += 1 }
            if waterRecord.glass2 { glasses += 1 }
            if waterRecord.glass3 { glasses += 1 }
            if waterRecord.glass4 { glasses += 1 }
            if waterRecord.glass5 { glasses += 1 }
            if waterRecord.glass6 { glasses += 1 }
            if waterRecord.glass7 { glasses += 1 }
            drankGlassesLabel.text = "\(glasses) " + "glasses".localized()
            if glasses == 8 {
                drankGlassesLabel.textColor = .incomeGreen
            } else {
                drankGlassesLabel.textColor = .label
            }
        }
    }
    
    lazy var waterImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "icon_cup")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
    }

    lazy var drankLabel = UILabel().then { label in
        label.text = "Drank".localized()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
    }

    lazy var drankGlassesLabel = UILabel().then { label in
        label.text = "0 " + "glasses".localized()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
    }

    lazy var goalImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "star.circle.fill")
        imageView.tintColor = .darkGray
    }

    lazy var goalLabel = UILabel().then { label in
        label.text = "Daily Goal".localized()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
    }

    lazy var goalGlassesLabel = UILabel().then { label in
        label.text = "8 " + "glasses".localized()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        selectionStyle = .none

        contentView.addSubview(waterImageView)
        contentView.addSubview(drankLabel)
        contentView.addSubview(drankGlassesLabel)
        contentView.addSubview(goalImageView)
        contentView.addSubview(goalLabel)
        contentView.addSubview(goalGlassesLabel)

        waterImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(20)
        }

        drankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(waterImageView.snp.right).offset(8)
            make.height.equalTo(15)
        }

        drankGlassesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(waterImageView.snp.right).offset(8)
            make.height.equalTo(25)
        }

        goalImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(waterImageView.snp.right).offset(150)
            make.size.equalTo(25)
        }

        goalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(goalImageView.snp.right).offset(8)
            make.height.equalTo(15)
        }

        goalGlassesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(goalImageView.snp.right).offset(8)
            make.height.equalTo(25)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
