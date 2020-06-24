//
//  UIColorExtension.swift
//  PreloaderAnimation
//
//  Created by Anton Larchenko on 24.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

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
