//
//  NetworkService.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//
import Alamofire
import Foundation
import RxSwift

final class NetworkService {
    private func searchData<T: Codable>(url: URL) async throws -> T {
        let publisher = AF.request(url, method: .get)
            .validate()
            .serializingDecodable(T.self)
        
        switch await publisher.result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func searchMusic(of section: Section) async throws -> [Music] {
        let query: (term: String, limit: Int) = switch section {
        case .spring:
            (term: "봄", limit: 5)
        default:
            (term: section.title, limit: 12)
        }
        
        var urlComp = URLComponents(string: "https://itunes.apple.com/search?")
        let queryItems = [
            URLQueryItem(name: "term", value: query.term),
            URLQueryItem(name: "country", value: "KR"),
            URLQueryItem(name: "limit", value: "\(query.limit)"),
            URLQueryItem(name: "media", value: "music")
        ]
        
        urlComp?.queryItems = queryItems
        
        guard let url = urlComp?.url else { throw NetworkError.invalidURL }
        
        let response: MusicResponse = try await searchData(url: url)
        return response.results
    }
}

extension NetworkService: ReactiveCompatible { }

extension Reactive where Base: NetworkService {
    func fetchMusic(of section: Section) -> Observable<[Music]> {
        Observable.create { [base] observer in
            let task = Task {
                do {
                    let result = try await base.searchMusic(of: section)
                    observer.on(.next(result))
                    observer.on(.completed)
                } catch {
                    observer.on(.error(error))
                }
            }
            
            return Disposables.create {
                task.cancel() // 구독이 dispose될 때 진행중인 task를 cancel

            }
        }
    }
}


