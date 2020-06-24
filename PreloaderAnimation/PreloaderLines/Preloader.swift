//
//  Preloader.swift
//  PreloaderAnimation
//
//  Created by Anton Larchenko on 24.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class Preloader: UIView {
    
    private let minLength: CGFloat = 0.05
    private var circleShapeLayers: [CAShapeLayer] = []
    
    private let yellowLineMaxLength: CGFloat = 1 - 0.42
    private let greenLineMaxLength: CGFloat = 1 - 0.09
    private let blueLineMaxLength: CGFloat = 1 - 0.2
    private let purpleLineMaxLength: CGFloat = 1 - 0.31
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        let yellowLine = createShapeLayer(color: UIColor(hex: 0xf7ce23, alpha: 1))
        let greenLine = createShapeLayer(color: UIColor(hex: 0x25ccc3, alpha: 1))
        let blueLine = createShapeLayer(color: UIColor(hex: 0x0787dc, alpha: 1))
        let purpleLine = createShapeLayer(color: UIColor(hex: 0x8f27cc, alpha: 1))
        
        circleShapeLayers = [greenLine, blueLine, purpleLine, yellowLine]
        circleShapeLayers.forEach { layer.addSublayer($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createShapeLayer(color: UIColor) -> CAShapeLayer {
        let circleShapeLayer = CAShapeLayer()
        circleShapeLayer.actions = ["strokeEnd" : NSNull(),
                                    "strokeStart" : NSNull(),
                                    "transform" : NSNull(),
                                    "strokeColor" : NSNull()]
        circleShapeLayer.backgroundColor = UIColor.clear.cgColor
        circleShapeLayer.strokeColor = color.cgColor
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.lineWidth = 10
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.strokeStart = 0
        circleShapeLayer.strokeEnd = minLength
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        circleShapeLayer.frame = bounds
        circleShapeLayer.path = UIBezierPath(
            arcCenter: center,
            radius: center.x,
            startAngle: 0,
            endAngle: CGFloat(Double.pi*2),
            clockwise: true).cgPath
        return circleShapeLayer
    }
    
    func startAnimating() {
        
        circleShapeLayers.forEach {
            
            var maxLength =  yellowLineMaxLength
            if $0.strokeColor == UIColor(hex: 0x0787dc, alpha: 1).cgColor {
                maxLength = blueLineMaxLength
            } else if $0.strokeColor == UIColor(hex: 0x8f27cc, alpha: 1).cgColor {
                maxLength = purpleLineMaxLength
            } else if $0.strokeColor == UIColor(hex: 0x25ccc3, alpha: 1).cgColor {
                maxLength = greenLineMaxLength
            }
            
            startStrokeAnimation(circleShapeLayer: $0, maxLength: maxLength)
        }
        
        if layer.animation(forKey: "rotation") == nil {
            startRotatingAnimation()
        }
    }
    
    private func startRotatingAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.isAdditive = true
        rotation.repeatCount = Float.infinity
        layer.add(rotation, forKey: "rotation")
    }
    
    private func startStrokeAnimation(circleShapeLayer: CAShapeLayer, maxLength: CGFloat) {
        let easeInOutSineTimingFunc = CAMediaTimingFunction(name: .easeInEaseOut)
        let progress: CGFloat = maxLength
        let endFromValue: CGFloat = circleShapeLayer.strokeEnd
        let endToValue: CGFloat = endFromValue + progress
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = endFromValue
        strokeEnd.toValue = endToValue
        strokeEnd.duration = 1.0
        strokeEnd.fillMode = CAMediaTimingFillMode.forwards
        strokeEnd.timingFunction = easeInOutSineTimingFunc
        strokeEnd.beginTime = 0
        strokeEnd.isRemovedOnCompletion = false
        
        let startFromValue: CGFloat = circleShapeLayer.strokeStart
        let startToValue: CGFloat = abs(endToValue - minLength)
        
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
            if circleShapeLayer.animation(forKey: "stroke") != nil {
                circleShapeLayer.transform = CATransform3DRotate(circleShapeLayer.transform, CGFloat.pi * 2, 0, 0, 1)
                circleShapeLayer.removeAnimation(forKey: "stroke")
                self.startStrokeAnimation(circleShapeLayer: circleShapeLayer, maxLength: maxLength)
            }
        }
        circleShapeLayer.add(pathAnim, forKey: "stroke")
        CATransaction.commit()
    }
    
    func stopAnimating() {
        circleShapeLayers.forEach { $0.removeAllAnimations() }
        layer.removeAllAnimations()
        
        circleShapeLayers.forEach { $0.transform = CATransform3DIdentity }
        layer.transform = CATransform3DIdentity
    }
    
}

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}
