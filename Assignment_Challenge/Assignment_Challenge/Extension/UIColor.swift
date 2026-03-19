//
//  UIColor.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/18/26.
//

import UIKit

extension UIColor {
    // 랜덤 밝은 색
    static var randomBright: UIColor {
        return UIColor(
            hue: CGFloat.random(in: 0...1),
            saturation: CGFloat.random(in: 0.55...0.65),
            brightness: CGFloat.random(in: 0.88...0.95),
            alpha: 1
        )
    }
    
    // 랜덤 파스텔 색
    static var randomPastel: UIColor {
        return UIColor(
            hue: CGFloat.random(in: 0...1),
            saturation: 0.35,
            brightness: 0.95,
            alpha: 1
        )
    }
}
