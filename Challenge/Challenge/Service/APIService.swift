//
//  APIService.swift
//  Challenge
//
//  Created by Hanjuheon on 3/16/26.
//

import Foundation
import RxSwift

enum NetworkError : Error {
    case invalidURL
    case dataFetchFail
    case decodingFail
}

class APIService {
    static let share = APIService()
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            session.dataTask(with:URLRequest(url: url)) { data, response, error in
                if let error = error {
                    observer(.failure(error))
                }
                guard let data = data,
                      let response = response as? HTTPURLResponse else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                do {
                    let decodeData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodeData))
                } catch {
                    observer(.failure(NetworkError.decodingFail))
                }
            }.resume()
            return Disposables.create()
        }
    }
}
