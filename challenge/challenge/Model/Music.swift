//
//  Music.swift
//  challenge
//
//  Created by 손영빈 on 3/12/26.
//

import Foundation

struct MusicResponse: Codable {
    let results: [Music]
}

struct Music: Codable, Hashable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl60: String? // 앨범커버
    let artworkUrl100: String?
}

struct MusicSection {
    let section: Section
    let items: [Music]
}
