//
//  MainViewModel.swift
//  Challenge
//
//  Created by Hanjuheon on 3/16/26.
//

import Foundation
import RxSwift

enum SeasonKeyword: String, CaseIterable, Hashable {
    case spring = "봄"
    case summer = "여름"
    case autumn = "가을"
    case winter = "겨울"
    
    var title: String {
        rawValue
    }
}

/// MainView Model
class MainViewModel {
    struct Input {
        let fetch: Observable<Void>
    }
    
    struct Output {
        let update: Observable<[SeasonKeyword : [Music]]>
    }
    
    func transform(input: Input) -> Output {
        let update = input.fetch
            // input.fetch에서 이벤트가 발생하면 Observable<[SeasonKeyword: [Music]]> 스트림을 생성
            // 새로운 fetch 이벤트가 오면 이전 fetch로 만든 스트림은 더 이상 보지 않고 가장 최근 fetch로 만든 스트림만 구독 (flatMapLatest)
            .flatMapLatest { _ -> Observable<[SeasonKeyword : [Music]]> in
                // SeasonKeyword 전체 케이스를 배열로 담고 map 실행
                // 결과값:(Observable<SeasonKeyword : [Music]>) 튜플 형태의 배열 제작
                let results = SeasonKeyword.allCases.map { keyword in
                    // url 체크
                    guard let url = URL(string: "https://itunes.apple.com/search?media=music&country=KR&term=\(keyword.title)") else {
                        return Observable.just((keyword, [Music]()))
                    }
                    
                    // API 호출
                    return APIService.share.fetch(url: url)
                        // 호출 결과 값을 튜플로 묶음
                        .map { (musicResponse: MusicResponse) in
                            (keyword, musicResponse.results)
                        }
                        // Observable로 생성
                        .asObservable()
                }

                //merge를 통해 옵져버 배열을 하나의 스트림으로 통합
                return Observable.merge(results)
                //scan 을 이용하여 스트림의 결과값들을 딕셔너리 형태로 누적
                    .scan(into: [SeasonKeyword : [Music]]()) { partial, element in
                        let (keyword, musics) = element
                        partial[keyword] = musics
                    }
            }
    
        return Output(update: update)
    }
}
