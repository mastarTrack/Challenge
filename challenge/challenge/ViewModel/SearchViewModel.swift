//
//  SearchViewModel.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import Foundation
import RxSwift

class SearchViewModel: ViewModel {
    
    private let errorSubject = PublishSubject<NetworkError>()
    
    struct Input {
        let searchText: Observable<String>
    }
    struct Output {
        let searchResult: Observable<([Podcast], [Music])>
        let error: Observable<NetworkError>
    }
    
    func transform(input: Input) -> Output {
        
        let searchText = input.searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .share()
        
        let podcast = searchText
            .flatMap { [weak self] term -> Observable<[Podcast]> in
                guard let self else { return .just([] as [Podcast])}
                guard let url = NetworkManager.shared.url(term: term, media: "podcast") else {
                    self.errorSubject.onNext(.requestError)
                    return .just([] as [Podcast])
                }
                return NetworkManager.shared.fetch(url: url)
                    .map { (response: PodcastResponse) in response.results }
                    .asObservable()
                    .catch { [weak self] error in
                        self?.errorSubject.onNext(error as! NetworkError)
                        return .just([] as [Podcast])
                    }
            }
        
        let music = searchText
            .flatMap { [weak self] term -> Observable<[Music]> in
                guard let self else { return .just([] as [Music]) }
                guard let url = NetworkManager.shared.url(term: term, media: "music") else {
                    self.errorSubject.onNext(.requestError)
                    return .just([] as [Music])}
                return NetworkManager.shared.fetch(url: url)
                    .map { (response: MusicResponse) in response.results }
                    .asObservable()
                    .catch { [weak self] error in
                        self?.errorSubject.onNext(error as! NetworkError)
                        return .just([] as [Music])
                    }
            }
        let searchResult = Observable.zip(podcast, music)
        
        return Output(searchResult: searchResult, error: errorSubject.asObservable())
    }
}
