//
//  MusicResponse.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//

nonisolated
struct MusicResponse: Codable {
    let results: [Music]
}

nonisolated
struct TvShowResponse: Codable {
    let results: [TvShow]
}

nonisolated
struct PodcastResponse: Codable {
    let results: [Podcast]
}
