//
//  MainViewModel.swift
//  challenge
//
//  Created by 손영빈 on 3/16/26.
//

//TODO: 1. List 묶어서 한번에 처리하는 방법, 2. Error 발생 시 print -> Alert로 변경

import Foundation
import RxSwift
import RxRelay

class HomeViewModel {
    private let disposeBag = DisposeBag()
    
    let springList = BehaviorRelay<[Music]>(value: [])
    let summerList = BehaviorRelay<[Music]>(value: [])
    let autumnList = BehaviorRelay<[Music]>(value: [])
    let winterList = BehaviorRelay<[Music]>(value: [])
    
    private func fetchMusicList(term: String, relay: BehaviorRelay<[Music]>) {
        guard let url = API.music(term: term, media: "music").url else { return }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { (response: MusicResponse) in
                relay.accept(response.results)
            }, onFailure: { error in
                if let error = error as? NetworkError {
                    switch error {
                    case .requestError:
                        print("요청 에러")
                    case .responseError:
                        print("응답 에러")
                    case .decodingError:
                        print("디코딩 에러")
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func fetchAllMusicList() {
        fetchMusicList(term: "봄", relay: springList)
        fetchMusicList(term: "여름", relay: summerList)
        fetchMusicList(term: "가을", relay: autumnList)
        fetchMusicList(term: "겨울", relay: winterList)
    }
}
