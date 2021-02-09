//
//  WaterCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/8/20.
//

import UIKit

class WaterCell: UICollectionViewCell {
    var drankRecord: DrankRecord? {
        didSet {
            guard let drankRecord = drankRecord else { return }
            if drankRecord.isDrank {
                viewProgress.setProgress(1.0)
                imageViewGlass.tintColor = .themeColor
                drankDateLabel.isHidden = false
                drankDateLabel.textColor = .themeColor
                drankDateLabel.text = drankRecord.drankTime?.timeString
                imageViewGlass.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(-8)
                }
            } else {
                viewProgress.setProgress(0.0)
                imageViewGlass.tintColor = UIColor.systemGray
                drankDateLabel.isHidden = true
                drankDateLabel.textColor = UIColor.systemGray
                imageViewGlass.snp.updateConstraints { make in
                    make.centerY.equalToSuperview()
                }
            }
        }
    }

    var shouldAnimate: Bool = false

    lazy var viewProgress = WaterProgressView().then { view in
        view.roundCorner = false
        view.trackColor = .tertiarySystemFill
        view.progressColor = UIColor.themeColor.withAlphaComponent(0.2)
    }

    lazy var imageViewGlass = UIImageView().then { imageView in
        imageView.image = UIImage(named: "icon_cup")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemGray
    }

    lazy var drankDateLabel = UILabel().then { label in
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(viewProgress)
        contentView.addSubview(imageViewGlass)
        contentView.addSubview(drankDateLabel)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        viewProgress.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageViewGlass.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(35)
        }
        drankDateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageViewGlass.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        drankDateLabel.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
