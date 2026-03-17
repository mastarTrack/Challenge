//
//  ViewModelProtocol.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/12/26.
//

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
