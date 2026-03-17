//
//  SearchViewModel.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import Foundation
import RxSwift

class SearchViewModel: ViewModel {
    struct Input {
        let searchText: Observable<String>
    }
    struct Output {
        let searchResult: Observable<([Podcast], [Music])>
    }
    
    func transform(input: Input) -> Output {
        
        let searchText = input.searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .share()
        
        let podcast = searchText
            .flatMap { term -> Observable<[Podcast]> in
                guard let url = NetworkManager.shared.url(term: term, media: "podcast") else { return .just([]) }
                return NetworkManager.shared.fetch(url: url)
                    .map { (response: PodcastResponse) in response.results }
                    .asObservable()
                    .catchAndReturn([] as [Podcast])
            }
        
        let music = searchText
            .flatMap { term -> Observable<[Music]> in
                guard let url = NetworkManager.shared.url(term: term, media: "music") else { return .just([]) }
                return NetworkManager.shared.fetch(url: url)
                    .map { (response: MusicResponse) in response.results }
                    .asObservable()
                    .catchAndReturn([] as [Music])
            }
        let searchResult = Observable.zip(podcast, music)
        
        return Output(searchResult: searchResult)
    }
}
