//
//  TvShow.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/17/26.
//

nonisolated
struct TvShow: Codable, Hashable {
    var trackId: Int
    var kind: String // 종류 (Podcast or tv-episode)
    
    var title: String // 에피소드 이름
    var artist: String // 출연진
    var collection: String? // Tv 시리즈 이름
    
    var artworkUrl100: String? = nil // 아트 사이즈 100
    var previewUrl: String? = nil // 프리뷰
    
    var shortDescription: String?
    var longDescription: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
    }
    
    enum CodingKeys: String, CodingKey {
        case trackId
        case kind
        
        case title = "trackName"
        case artist = "artistName"
        case collection = "collectionName"
        
        case artworkUrl100
        case previewUrl
        
        case shortDescription
        case longDescription
    }
}
