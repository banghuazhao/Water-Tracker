//
//  WaterProgressView.swift
//  Water Tracker
//
//  Created by Banghua Zhao on 10/8/20.
//

import UIKit

// -------------------------------------------------------------------------------------------------------------------------------------------------
class WaterProgressView: UIView {
    @IBInspectable var roundCorner: Bool = true
    @IBInspectable var progressColor: UIColor = .themeColor
    @IBInspectable var trackColor: UIColor = UIColor.systemGray.withAlphaComponent(0.3)

    private var trackLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    override func draw(_ rect: CGRect) {
        let trackWidth = rect.size.width

        let bezierPath = UIBezierPath()
        if roundCorner {
            bezierPath.move(to: CGPoint(x: trackWidth / 2, y: rect.size.height - (trackWidth / 2)))
            bezierPath.addLine(to: CGPoint(x: trackWidth / 2, y: rect.origin.y + (trackWidth / 2)))
        } else {
            bezierPath.move(to: CGPoint(x: trackWidth / 2, y: rect.size.height))
            bezierPath.addLine(to: CGPoint(x: trackWidth / 2, y: rect.origin.y))
        }

        [trackLayer, progressLayer].forEach { layer in
            layer.path = bezierPath.cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = trackWidth
            if roundCorner {
                layer.lineCap = .round
            }
        }

        trackLayer.strokeColor = trackColor.cgColor

        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.strokeEnd = 0

        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func setProgress(_ value: CGFloat, duration: TimeInterval = 2.0) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.fromValue = 0
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
