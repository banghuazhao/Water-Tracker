//
//  ReminderAddCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 2021/1/31.
//

import UIKit

class ReminderAddCell: UICollectionViewCell {
    lazy var addImageView = UIImageView().then { (imageView) in
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .themeColor
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 6
        contentView.addSubview(addImageView)
        addImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(28)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
