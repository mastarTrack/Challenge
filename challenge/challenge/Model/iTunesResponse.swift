//
//  iTunesResponse.swift
//  challenge
//
//  Created by 손영빈 on 3/19/26.
//

import Foundation

struct iTunesResponse<T: Codable>: Codable {
    let results: [T]
}

struct Music: Codable, Hashable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl60: String? // 앨범커버
    let artworkUrl100: String?
}

struct Podcast: Codable, Hashable {
    let trackName: String?
    let artistName: String?
    let artworkUrl100: String?
    let artworkUrl600: String?
}
