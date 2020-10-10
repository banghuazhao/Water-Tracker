//
//  WaterCell.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/8/20.
//

import UIKit

// -------------------------------------------------------------------------------------------------------------------------------------------------
class WaterCell: UICollectionViewCell {
    var isDrank: Bool? {
        didSet {
            guard let isDrank = isDrank else { return }
            if isDrank {
                viewProgress.setProgress(1.0)
                imageViewGlass.tintColor = .themeColor
            } else {
                viewProgress.setProgress(0.0)
                imageViewGlass.tintColor = UIColor.systemGray
            }
        }
    }

    lazy var viewProgress = WaterProgressView().then { view in
        view.roundCorner = false
        view.trackColor = .tertiarySystemFill
        view.progressColor = UIColor.themeColor.withAlphaComponent(0.2)
    }

    lazy var imageViewGlass = UIImageView().then { imageView in
        if #available(iOS 14.0, *) {
            imageView.image = UIImage(systemName: "square.bottomhalf.fill")
        } else {
            imageView.image = UIImage(systemName: "square.righthalf.fill")
        }
        
        imageView.tintColor = .systemGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(viewProgress)
        contentView.addSubview(imageViewGlass)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        viewProgress.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageViewGlass.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(35)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
