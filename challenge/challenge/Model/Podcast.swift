//
//  Podcast.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import Foundation

struct PodcastResponse: Codable {
    let results: [Podcast]
}

struct Podcast: Codable, Hashable {
    let trackName: String?
    let artistName: String?
    let artworkUrl100: String?
    let artworkUrl600: String?
}
