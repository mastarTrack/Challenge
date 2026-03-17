//
//  NetworkManager.swift
//  challenge
//
//  Created by 손영빈 on 3/15/26.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case requestError // 요청 자체가 에러
    case responseError // 요청 후 응답이 에러
    case decodingError // 디코딩 실패
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func url(term: String, media: String) -> URL? {
        var componenets = URLComponents(string: "https://itunes.apple.com/search")
        componenets?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: media)
        ]
        return componenets?.url
    }
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    observer(.failure(NetworkError.requestError))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.responseError))
                    return
                }
                guard let data = data else {
                    observer(.failure(NetworkError.responseError))
                    return
                }
                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(data))
                } catch {
                    observer(.failure(NetworkError.decodingError))
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
