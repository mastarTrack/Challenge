//
//  Untitled.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/12/26.
//
import RxSwift

final class MusicViewModel: ViewModel {
    struct Input {
        let fetchData: Observable<Void>
    }
    
    struct Output {
        let spring: Observable<[Music]>
        let summer: Observable<[Music]>
        let autumn: Observable<[Music]>
        let winter: Observable<[Music]>
}
    
    func transform(_ input: Input) -> Output {
        let spring = input.fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .spring)
            }
        
        let summer = input.fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .summer)
            }
        
        let autumn = input.fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .autumn)
            }
        
        let winter = input.fetchData
            .flatMap { [networkService] in
                networkService.rx.fetchMusic(of: .winter)
            }

        return Output(
            spring: spring,
            summer: summer,
            autumn: autumn,
            winter: winter
            )
    }
    
    let networkService = NetworkService()
}
