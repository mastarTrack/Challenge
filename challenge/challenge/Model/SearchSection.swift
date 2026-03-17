//
//  SearchSection.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import Foundation

enum SearchSection: Int, CaseIterable {
    case podcast
    case music
    
    var layout: SearchLayout{
        switch self {
        case .podcast:
            return .poster
        case .music:
            return .list
        }
    }
}

enum SearchLayout {
    case poster
    case list
}
