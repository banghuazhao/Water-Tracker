//
//  RecordTitleCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class RecordTitleCell: UITableViewCell {
    lazy var recordLabel = UILabel().then { label in
        label.text = "Record".localized()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
    }

    lazy var seeAllButton = UIButton().then { button in
        button.setTitleColor(.themeColor, for: .normal)
        button.setTitle("See All".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }

    lazy var arrowImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .themeColor
        imageView.contentMode = .scaleAspectFit
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        selectionStyle = .none
        contentView.addSubview(recordLabel)
        contentView.addSubview(seeAllButton)
        contentView.addSubview(arrowImageView)

        recordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }

        seeAllButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(100)
        }

        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(15)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
