//
//  Untitled.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/12/26.
//
import RxSwift

final class MusicViewModel {
    
    struct Output {
        let musics: Single<[[Item]]>
    }
    
    func fetchMusics() -> Output {
        let data: [Music] = [
            Music(trackId: 1001, title: "Blinding Lights", artist: "The Weeknd", collection: "After Hours"),
            Music(trackId: 1002, title: "Shape of You", artist: "Ed Sheeran", collection: "÷ (Divide)"),
            Music(trackId: 1003, title: "Hype Boy", artist: "NewJeans", collection: "NewJeans 1st EP"),
            Music(trackId: 1004, title: "Bad Guy", artist: "Billie Eilish", collection: "When We All Fall Asleep, Where Do We Go?"),
            Music(trackId: 1005, title: "Dynamite", artist: "BTS", collection: "Dynamite (Single)"),
            Music(trackId: 1006, title: "Levitating", artist: "Dua Lipa", collection: "Future Nostalgia"),
            Music(trackId: 1007, title: "Peaches & Cream", artist: "EXO", collection: "Don't Fight the Feeling"),
            Music(trackId: 1008, title: "Stay", artist: "The Kid LAROI & Justin Bieber", collection: "F*CK LOVE 3: OVER YOU"),
            Music(trackId: 1009, title: "Super Shy", artist: "NewJeans", collection: "Get Up")
        ]

        let spring = data.map { Item.spring($0) }
        let summer = data.map { Item.summer($0) }
        let autumn = data.map { Item.autumn($0) }
        let winter = data.map { Item.winter($0) }
        
        let musics = Single<[[Item]]>.create { observer in
            observer(.success([spring, summer, autumn, winter]))
            return Disposables.create()
        }
        
        return Output(
            musics: musics
            )
    }
}
