//
//  MoreCell.swift
//  Apps Bay
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {
    var moreItem: MoreItem? {
        didSet {
            guard let moreItem = moreItem else { return }
            iconView.image = moreItem.icon?.withRenderingMode(.alwaysTemplate)
            titleLabel.text = moreItem.title
        }
    }

    lazy var iconView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.label
    }

    lazy var titleLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.label
        label.lineBreakMode = .byTruncatingTail
    }

    lazy var rightArrowImageView = UIImageView().then { imageView in
        imageView.tintColor = UIColor.systemGray
        imageView.image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightArrowImageView)

        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalTo(rightArrowImageView.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }

        rightArrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
