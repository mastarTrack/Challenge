//
//  TvShow.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/17/26.
//

nonisolated
struct TvShow: Codable, Hashable {
    var trackId: Int
    
    var title: String // 에피소드 이름
    var artist: String // 출연진
    var collection: String? // Tv 시리즈 이름
    
    var previewUrl: String? = nil // 프리뷰
    var artworkUrl100: String? = nil // 아트 사이즈 100
    var artworkUrl600: String? = nil // 아트 사이즈 600
    
    var shortDescription: String?
    var longDescription: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
    }
    
    enum CodingKeys: String, CodingKey {
        case trackId
        
        case title = "trackName"
        case artist = "artistName"
        case collection = "collectionName"
        
        case previewUrl
        case artworkUrl100
        case artworkUrl600
        
        case shortDescription
        case longDescription
    }
}
