//
//  Podcast.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/17/26.
//

nonisolated
struct Podcast: Codable, Hashable {
    var trackId: Int
    
    var title: String // 팟캐스트 이름
    var artist: String // 아티스트
    
    var feedUrl: String? // 피드 상세내역
    var previewUrl: String? = nil // 프리뷰
    var artworkUrl600: String? = nil // 아트 사이즈 600
    var artworkUrl100: String? = nil // 아트 사이즈 100
    
    
    var genre: String? // 장르
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
    }
    
    enum CodingKeys: String, CodingKey {
        case trackId
        
        case title = "trackName"
        case artist = "artistName"
        
        case feedUrl
        case previewUrl
        case artworkUrl100
        case artworkUrl600
        
        
        case genre = "primaryGenreName"
    }
}
