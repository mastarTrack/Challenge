//
//  SearchSection.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import Foundation

extension SearchSection: SectionHeader {}

enum SearchSection: Int, CaseIterable {
    case podcast
    case music
    
    var title: String {
        switch self {
        case .podcast:
            return "Podcast"
        case .music:
            return "Music"
        }
    }
    
    var subTitle: String {
        switch self {
        case .podcast:
            return "Podcast 검색 결과"
        case .music:
            return "Music 검색 결과"
        }
    }
    
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
