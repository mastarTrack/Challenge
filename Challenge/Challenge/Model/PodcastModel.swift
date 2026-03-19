//
//  PodcastModel.swift
//  Challenge
//
//  Created by Hanjuheon on 3/17/26.
//

import Foundation

struct PodcastResponse: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

struct Podcast: Decodable, Hashable {
    let wrapperType: String?
    let kind: String?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?

    let artworkUrl60: String?
    let artworkUrl600: String?

    let collectionPrice: Double?
    let trackPrice: Double?
    let collectionHdPrice: Double?
    let releaseDate: String?

    let collectionExplicitness: String?
    let trackExplicitness: String?

    let trackCount: Int?
    let trackTimeMillis: Int?

    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?

    let genreIds: [String]?
    let genres: [String]?
}
