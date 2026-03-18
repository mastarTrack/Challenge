//
//  ResultViewController.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/17/26.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ResultViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private let searchKeyword: Observable<String>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        print("result view loaded")
    }
    
    //MARK: init
    init(viewModel: HomeViewModel, searchKeyword: Observable<String>) {
        self.viewModel = viewModel
        self.searchKeyword = searchKeyword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: bind
    private func bind() {
        let input = HomeViewModel.Input(
            fetchData: .empty(),
            searchText: searchKeyword
        )
        
        let output = viewModel.transform(input)
        
        output.tvShow
            .subscribe(onNext: {
                print($0)
            }, onError: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        output.podcast
            .subscribe(onNext: {
                print($0)
            }, onError: {
                print($0)
            })
            .disposed(by: disposeBag)
    }

}

