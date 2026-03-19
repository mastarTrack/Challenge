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
        
        let podcast: Observable<[Podcast]> = search(searchText: searchText, media: "podcast")
        let music: Observable<[Music]> = search(searchText: searchText, media: "music")
        let searchResult = Observable.zip(podcast, music).share()
        
        return Output(searchResult: searchResult, error: errorSubject.asObservable())
    }
    
    private func search<T: Codable>(searchText: Observable<String>, media: String) -> Observable<[T]> {
        searchText.flatMap { [weak self] term -> Observable<[T]> in
            guard let self else { return .just([])}
            guard let url = NetworkManager.shared.url(term: term, media: media) else {
                self.errorSubject.onNext(.requestError)
                return .just([])
            }
            return NetworkManager.shared.fetch(url: url)
                .map { (response: iTunesResponse<T>) in response.results }
                .asObservable()
                .catch { [weak self] error in
                    self?.errorSubject.onNext(error as! NetworkError)
                    return .just([])
                }
        }
    }
}
