//
//  API.swift
//  challenge
//
//  Created by 손영빈 on 3/15/26.
//

import Foundation

enum API {
    case music(term: String, media: String)
    
    var url: URL? {
        var componenets = URLComponents(string: "https://itunes.apple.com/search")
        
        switch self {
        case .music(let term, let media):
            componenets?.queryItems = [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "media", value: media)
            ]
            return componenets?.url
        }
    }
}
