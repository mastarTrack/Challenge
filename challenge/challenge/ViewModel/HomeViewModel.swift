//
//  MainViewModel.swift
//  challenge
//
//  Created by 손영빈 on 3/16/26.
//

//TODO: 1. List 묶어서 한번에 처리하는 방법

import Foundation
import RxSwift

class HomeViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let initialized: Observable<Void>
    }
    
    struct Output {
        let musicInfo: Observable<[MusicSection]>
    }
    
    func transform(input: Input) -> Output {
        let musicInfo = input.initialized // 초기화 이벤트 시
            .flatMap { [weak self] _ -> Observable<[MusicSection]> in // Observable로 반환
                guard let self else { return .error(NetworkError.requestError) }
                return self.fetchAllSections() // fetchAllSections 결과
            }
        return Output(musicInfo: musicInfo)
    }
    
    private func fetchAllSections() -> Observable<[MusicSection]> {
        // Section 정보용 pairs 생성(Section 정보, term 정보)
        let sectionInfo: [(Section, String)] = [
            (.spring, "봄"),
            (.summer, "여름"),
            (.autumn, "가을"),
            (.winter, "겨울")
        ]
        // URL 생성 (compactMap으로 생성 실패 시 처리)
        let observable = sectionInfo.compactMap { section, term -> Observable<MusicSection>? in
            guard let url = API.music(term: term, media: "music").url else { return nil }
            return NetworkManager.shared.fetch(url: url)
                .map { (response: MusicResponse) in // MusicResponse -> MusicSection으로 반환
                    MusicSection(section: section, items: response.results)
                }.asObservable()
        }
        return Observable.zip(observable) // 묶어서 반환
    }
}
