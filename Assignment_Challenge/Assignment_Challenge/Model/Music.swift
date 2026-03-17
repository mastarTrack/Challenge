//
//  Music.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/12/26.
//

nonisolated
struct Music: Hashable {
    var trackId: Int
    var title: String // 곡 제목
    var artist: String // 가수
    var collection: String // 앨범 이름
    
    var artworkUrl30: String? = nil // 앨범 아트 사이즈 30
    var artworkUrl60: String? = nil // 앨범 아트 사이즈 60
    var previewUrl: String? = nil // 미리듣기
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
    }
}
