//
//  ModelProtocol.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/18/26.
//

enum ModelType {
    case music
    case podcast
    case tvShow
}

protocol Model: Hashable, Equatable {
    var modelType: ModelType { get }
}
