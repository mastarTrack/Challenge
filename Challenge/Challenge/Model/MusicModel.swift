//
//  MusicModel.swift
//  Challenge
//
//  Created by Hanjuheon on 3/16/26.
//

struct MusicResponse: Decodable {
    let resultCount: Int
    let results: [Music]
}

struct Music: Decodable, Hashable, Sendable {
    /// 응답 데이터의 최상위 타입
    /// 예: "track"
    let wrapperType: String?
    
    /// 결과 데이터의 종류
    /// 예: "song"
    let kind: String?
    
    /// 아티스트 고유 ID
    let artistId: Int?
    
    /// 앨범(컬렉션) 고유 ID
    let collectionId: Int?
    
    /// 트랙(곡) 고유 ID
    let trackId: Int
    
    /// 아티스트 이름
    let artistName: String?
    
    /// 앨범명
    let collectionName: String?
    
    /// 곡 제목
    let trackName: String?
    
    /// 아티스트 페이지 URL
    let artistViewUrl: String?
    
    /// 앨범 페이지 URL
    let collectionViewUrl: String?
    
    /// 곡 페이지 URL
    let trackViewUrl: String?
    
    /// 곡 미리듣기 URL
    let previewUrl: String?
    
    /// 60x60 사이즈 앨범 이미지 URL
    let artworkUrl60: String?
    
    /// 100x100 사이즈 앨범 이미지 URL
    let artworkUrl100: String?
    
    /// 앨범 가격
    let collectionPrice: Double?
    
    /// 곡 가격
    let trackPrice: Double?
    
    /// 발매일
    let releaseDate: String?
    
    /// 총 디스크 수
    let discCount: Int?
    
    /// 현재 곡이 속한 디스크 번호
    let discNumber: Int?
    
    /// 앨범 내 총 트랙 수
    let trackCount: Int?
    
    /// 앨범 내 현재 트랙 번호
    let trackNumber: Int?
    
    /// 곡 길이 (밀리초)
    let trackTimeMillis: Int?
    
    /// 국가 코드
    let country: String?
    
    /// 대표 장르명
    let primaryGenreName: String?
    
    // Hashable 식별을 위해 가급적 유일한 값인 trackId를 기준으로 고정하는 것이 좋습니다.
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
    }
    
    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}


let mockMusics: [Music] = [
    Music(wrapperType: nil, kind: nil, artistId: 1, collectionId: 1, trackId: 1, artistName: "아이유", collectionName: "앨범1", trackName: "밤편지", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 2, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 3, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 4, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 5, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 6, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 7, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 8, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 9, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 10, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 11, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil),
    Music(wrapperType: nil, kind: nil, artistId: 2, collectionId: 2, trackId: 12, artistName: "NewJeans", collectionName: "앨범2", trackName: "Ditto", artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, primaryGenreName: nil)
]
