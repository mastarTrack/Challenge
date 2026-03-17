//
//  Section.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import Foundation

extension HomeSection: SectionHeader {}

enum HomeSection: Int, CaseIterable {
    case spring
    case summer
    case autumn
    case winter
    
    var title: String {
        switch self {
        case .spring:
            return "봄 Best"
        case .summer:
            return "여름"
        case .autumn:
            return "가을"
        case .winter:
            return "겨울"
        }
    }
    
    var subTitle: String {
        switch self {
        case .spring:
            return "봄에 어울리는 음악 Best 5"
        case .summer:
            return "여름에 어울리는 음악"
        case .autumn:
            return "가을에 어울리는 음악"
        case .winter:
            return "겨울에 어울리는 음악"
        }
    }
    
    var layout: LayoutType {
        switch self {
        case .spring:
            return .card
        default:
            return .list
        }
    }
}

enum LayoutType {
    case card
    case list
}
