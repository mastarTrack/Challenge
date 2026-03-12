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

struct Music: Codable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artwork60: String? // 앨범커버
    let artwork100: String?
}
