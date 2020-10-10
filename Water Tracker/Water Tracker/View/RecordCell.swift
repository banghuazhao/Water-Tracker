//
//  RecordCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import SwiftDate
import UIKit

class RecordCell: UITableViewCell {
    var waterRecord: WaterRecord? {
        didSet {
            guard let waterRecord = waterRecord, let date = waterRecord.date else {
                return
            }
            dateLabel.text = date.toFormat("yyyy-MM-dd")
            var glasses = 0
            if waterRecord.glass0 { glasses += 1 }
            if waterRecord.glass1 { glasses += 1 }
            if waterRecord.glass2 { glasses += 1 }
            if waterRecord.glass3 { glasses += 1 }
            if waterRecord.glass4 { glasses += 1 }
            if waterRecord.glass5 { glasses += 1 }
            if waterRecord.glass6 { glasses += 1 }
            if waterRecord.glass7 { glasses += 1 }
            glassesLabel.text = "\(glasses) " + "glasses".localized()
            if glasses == 8 {
                glassesLabel.textColor = .incomeGreen
            } else {
                glassesLabel.textColor = .label
            }
        }
    }

    lazy var dateLabel = UILabel().then { label in
        label.font = UIFont.systemFont(ofSize: 16)
    }

    lazy var glassesLabel = UILabel().then { label in
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        selectionStyle = .none

        contentView.addSubview(dateLabel)
        contentView.addSubview(glassesLabel)

        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }

        glassesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
