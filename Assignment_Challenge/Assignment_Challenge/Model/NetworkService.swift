//
//  NetworkService.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//
import Alamofire
import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidURL
}

final class NetworkService {
    private let baseURL = "https://itunes.apple.com/search?"
    
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
    
    // 음악 정보
    fileprivate func fetchMusic(of section: MusicCollectionView.Section) async throws -> [Music] {
        let query: (term: String, limit: Int) = switch section {
        case .spring:
            (term: "봄", limit: 5)
        default:
            (term: section.title, limit: 12)
        }
        
        var urlComp = URLComponents(string: baseURL)
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
    
    // 팟캐스트 검색
    fileprivate func searchPodcast(with text: String) async throws -> [Podcast] {
        var urlComp = URLComponents(string: baseURL)
        let queryItems = [
            URLQueryItem(name: "term", value: text),
            URLQueryItem(name: "country", value: "KR"),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "media", value: "podcast")
        ]
        
        urlComp?.queryItems = queryItems
        
        guard let url = urlComp?.url else { throw NetworkError.invalidURL }
        
        let response: PodcastResponse = try await searchData(url: url)
        return response.results
    }
    
    // tvShow 검색
    fileprivate func searchTvShow(with text: String) async throws -> [TvShow] {
        var urlComp = URLComponents(string: baseURL)
        let queryItems = [
            URLQueryItem(name: "term", value: text),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "media", value: "tvShow")
        ]
        
        urlComp?.queryItems = queryItems
        
        guard let url = urlComp?.url else { throw NetworkError.invalidURL }
        
        let response: TvShowResponse = try await searchData(url: url)
        return response.results
    }
}

extension NetworkService: ReactiveCompatible { }

extension Reactive where Base: NetworkService {
    func fetchMusic(of section: MusicCollectionView.Section) -> Single<[Music]> {
        Single.create { [base] observer in
            let task = Task {
                do {
                    let result = try await base.fetchMusic(of: section)
                    observer(.success(result))
                } catch {
                    observer(.failure(error))
                }
            }
            
            return Disposables.create {
                task.cancel() // 구독이 dispose될 때 진행중인 task를 cancel

            }
        }
    }
    
    func searchPodcast(with text: String) -> Observable<[Podcast]> {
        Observable.create { [base] observer in
            let task = Task {
                do {
                    let result = try await base.searchPodcast(with: text)
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
    
    func searchTvShow(with text: String) -> Observable<[TvShow]> {
        Observable.create { [base] observer in
            let task = Task {
                do {
                    let result = try await base.searchTvShow(with: text)
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


