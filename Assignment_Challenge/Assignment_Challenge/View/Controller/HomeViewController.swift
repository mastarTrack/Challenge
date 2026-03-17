//
//  ViewController.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/11/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class HomeViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = MusicViewModel()
    
    let homeView = HomeView()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        
        bind(viewModel: viewModel)

    }
    
    private func bind(viewModel: MusicViewModel) {
        let output = viewModel.fetchMusics()
        
        output.musics
            .subscribe(onSuccess: { [weak self] in
                self?.homeView.setSnapshot(with: $0)
            }, onFailure: {
                print("\($0)")
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func setNavigationController() {
        self.title = "Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
    }
}
