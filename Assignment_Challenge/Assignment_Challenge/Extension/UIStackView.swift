//
//  UILabel.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//

import UIKit

extension UIStackView {
    // 곡 정보 레이블 스택(세로) 생성용
    convenience init(vertical views: [UIView]) {
        self.init(frame: .zero)
        views.forEach { addArrangedSubview($0) }
        axis = .vertical
        alignment = .leading
        spacing = 4
    }
    
    // 곡 정보 스택(가로) 생성용
    convenience init(horizontal views: [UIView]) {
        self.init(frame: .zero)
        views.forEach { addArrangedSubview($0) }
        axis = .horizontal
        spacing = 10
        alignment = .center
    }
}
