//
//  SearchResultViewModel.swift
//  Challenge
//
//  Created by Hanjuheon on 3/18/26.
//

import Foundation
import RxSwift


enum SearchItem: Hashable {
    case podcast(Podcast)
    case music(Music)
}

enum MediaType: String, CaseIterable, Hashable {
    case podcast = "podcast" 
    case music = "music"
    
    var title: String {
        rawValue
    }
}

class SearchResultViewModel {
    struct Input {
        let fatch: Observable<String>
    }
    
    struct Output {
        let fatchItem: Observable<(music: [Music], podcast: [Podcast])>
    }
    
    func transForm(input: Input) -> Output {
        let fatch = input.fatch
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<(music: [Music], podcast: [Podcast])> in
                guard let musicUrl = URL(string: "https://itunes.apple.com/search?media=music&country=KR&term=\(query)"),
                      let podCastUrl = URL(string: "https://itunes.apple.com/search?media=podcast&country=KR&term=\(query)")
                else { return .just((music: [], podcast: [])) }
                
                let musicFatch = APIService.share.fetch(url: musicUrl).map { (musicResponse: MusicResponse) in
                    musicResponse.results }.asObservable()
                
                let podcastFatch = APIService.share.fetch(url: podCastUrl).map{ (podcastResponse: PodcastResponse) in
                    podcastResponse.results }.asObservable()
                
                return Observable.combineLatest(musicFatch, podcastFatch) { musics, podcasts in
                    (music: musics, podcast: podcasts)
                }
            }
        return Output(
            fatchItem: fatch
        )
    }
    
}
