//
//  Untitled.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/12/26.
//
import RxSwift

final class HomeViewModel: ViewModel {
    struct Input {
        let fetchData: Observable<Void>
        let searchText: Observable<String>
    }
    
    struct Output {
        let spring: Observable<[Music]>
        let summer: Observable<[Music]>
        let autumn: Observable<[Music]>
        let winter: Observable<[Music]>
        
        let tvShow: Observable<[TvShow]>
        let podcast: Observable<[Podcast]>
    }
    
    func transform(_ input: Input) -> Output {
        // Music
        let fetchData = input.fetchData.share()
        
        let spring = fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .spring)
            }
        
        let summer = fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .summer)
            }
        
        let autumn = fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .autumn)
            }
        
        let winter = fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .winter)
            }
        
        // TVShow, Podcast
        let searchText = input.searchText.share()
        
        let tvShow = searchText
            .flatMapLatest { [networkService] in
                networkService.rx.searchTvShow(with: $0)
            }
        
        let podcast = searchText
            .flatMapLatest { [networkService] in
                networkService.rx.searchPodcast(with: $0)
            }

        return Output(
            spring: spring,
            summer: summer,
            autumn: autumn,
            winter: winter,
            tvShow: tvShow,
            podcast: podcast
            )
    }
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
