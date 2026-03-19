//
//  Untitled.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/12/26.
//
import RxSwift
import Foundation

final class HomeViewModel: ViewModel {
    struct Input {
        let fetchData: Observable<Void>
        let searchText: Observable<String>
        let playMusic: Observable<MusicCollectionView.Item?>
    }
    
    struct Output {
        let spring: Observable<[Music]>
        let summer: Observable<[Music]>
        let autumn: Observable<[Music]>
        let winter: Observable<[Music]>
        
        let tvShow: Observable<[TvShow]>
        let podcast: Observable<[Podcast]>
        
        let musicPreviewTarget: Observable<Result<(isNew: Bool, music: Music), Error>>
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

        // previewMusic
        let target: Observable<Result<(isNew: Bool, music: Music), Error>> = input.playMusic
            .withUnretained(self) // self를 가져오는데 강한 참조는 x, self가 없으면 flatMap 연산 x
            .flatMap { `self`, item in
                self.fetchPreviewTarget(item: item)
                    .map {
                        .success($0)
                    }
                    .catch {
                        .just(.failure($0))
                    }
            }
        
        return Output(
            spring: spring,
            summer: summer,
            autumn: autumn,
            winter: winter,
            tvShow: tvShow,
            podcast: podcast,
            musicPreviewTarget: target
            )
    }
    
    enum TargetError: Error {
        case invalidTarget
    }
    
    private let networkService: NetworkService
    private var currentPreview: Music?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension HomeViewModel {
    private func fetchPreviewTarget(item: MusicCollectionView.Item?) -> Observable<(isNew: Bool, music: Music)> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            switch item {
            case .spring(let music):
                if self.currentPreview == music { // 현재 재생중인 곡과 동일한 곡이 선택되었을 경우
                    
                    guard let preview = currentPreview else { return Disposables.create() }
                    
                    observer.on(.next((false, preview)))
                    observer.on(.completed)
                    
                } else { // 다른 곡이 선택되었을 경우
                    currentPreview = music // 현재 재생중인 곡 변경
                    
                    guard let preview = currentPreview else { return Disposables.create() }
                    
                    observer.on(.next((true, preview)))
                    observer.on(.completed)
                }

            default:
                observer.onError(TargetError.invalidTarget)
            }
            
            return Disposables.create()
        }
    }
}
