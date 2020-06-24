//
//  Line4.swift
//  PreloaderAnimation
//
//  Created by Anton Larchenko on 24.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class Line4: UIView {
    
    let MinStrokeLength: CGFloat = 0.05
    let MaxStrokeLength: CGFloat = 0.8
    let circleShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        initShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initShapeLayer() {
        circleShapeLayer.actions = ["strokeEnd" : NSNull(),
                                    "strokeStart" : NSNull(),
                                    "transform" : NSNull(),
                                    "strokeColor" : NSNull()]
        circleShapeLayer.backgroundColor = UIColor.clear.cgColor
        circleShapeLayer.strokeColor = UIColor(hex: 0x25ccc3, alpha: 1).cgColor
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineWidth = 10
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.strokeStart = 0
        circleShapeLayer.strokeEnd = MinStrokeLength
        let center = CGPoint(x: bounds.width*0.5, y: bounds.height*0.5)
        circleShapeLayer.frame = bounds
        circleShapeLayer.path = UIBezierPath(arcCenter: center,
                                                        radius: center.x,
                                                        startAngle: 0,
                                                        endAngle: CGFloat(Double.pi*2),
                                                        clockwise: true).cgPath
        layer.addSublayer(circleShapeLayer)
    }
    
    func startAnimating() {
        if layer.animation(forKey: "rotation") == nil {
            startStrokeAnimation()
            startRotatingAnimation()
        }
    }
    
    private func startRotatingAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi*2
        rotation.duration = 2.2
        rotation.isCumulative = true
        rotation.isAdditive = true
        rotation.repeatCount = Float.infinity
        layer.add(rotation, forKey: "rotation")
    }
    
    private func startStrokeAnimation() {
        let easeInOutSineTimingFunc = CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1.0)
        let progress: CGFloat = MaxStrokeLength
        let endFromValue: CGFloat = circleShapeLayer.strokeEnd
        let endToValue: CGFloat = endFromValue + progress
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = endFromValue
        strokeEnd.toValue = endToValue
        strokeEnd.duration = 1.0
        strokeEnd.fillMode = CAMediaTimingFillMode.forwards
        strokeEnd.timingFunction = easeInOutSineTimingFunc
        strokeEnd.beginTime = 0.1
        strokeEnd.isRemovedOnCompletion = false
        let startFromValue: CGFloat = circleShapeLayer.strokeStart
        let startToValue: CGFloat = abs(endToValue - MinStrokeLength)
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.fromValue = startFromValue
        strokeStart.toValue = startToValue
        strokeStart.duration = 0.4
        strokeStart.fillMode = CAMediaTimingFillMode.forwards
        strokeStart.timingFunction = easeInOutSineTimingFunc
        strokeStart.beginTime = strokeEnd.beginTime + strokeEnd.duration + 0.2
        strokeStart.isRemovedOnCompletion = false
        let pathAnim = CAAnimationGroup()
        pathAnim.animations = [strokeEnd, strokeStart]
        pathAnim.duration = strokeStart.beginTime + strokeStart.duration
        pathAnim.fillMode = CAMediaTimingFillMode.forwards
        pathAnim.isRemovedOnCompletion = false
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if self.circleShapeLayer.animation(forKey: "stroke") != nil {
                self.circleShapeLayer.transform = CATransform3DRotate(self.circleShapeLayer.transform, CGFloat(Double.pi*2) * progress, 0, 0, 1)
                self.circleShapeLayer.removeAnimation(forKey: "stroke")
                self.startStrokeAnimation()
            }
        }
        circleShapeLayer.add(pathAnim, forKey: "stroke")
        CATransaction.commit()
    }
    
    func stopAnimating() {
        circleShapeLayer.removeAllAnimations()
        layer.removeAllAnimations()
        circleShapeLayer.transform = CATransform3DIdentity
        layer.transform = CATransform3DIdentity
    }
    
}
