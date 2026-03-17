//
//  ViewModel.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
