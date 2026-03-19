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

    weak var coordinator: AppCoordinator?
    let viewModel: HomeViewModel
    
    private let disposeBag = DisposeBag()
    private let homeView = HomeView()
    
    let searchKeywordRelay = BehaviorRelay<String>(value: "")
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        bind()
    }
    
    //MARK: init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: bind
    private func bind() {
        if let searchBar = navigationItem.searchController?.searchBar {
            searchBar.rx.text.orEmpty
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .bind(to: searchKeywordRelay)
                .disposed(by: disposeBag)
        }
        
        let input = HomeViewModel.Input(
            fetchData: .just(()),
            searchText: .empty()
        )
        
        let output = viewModel.transform(input)
        
        let spring = output.spring
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.spring($0)
                }
            }
        
        let summer = output.summer
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.summer($0)
                }
            }
        
        let autumn = output.autumn
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.autumn($0)
                }
            }
        
        let winter = output.winter
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.winter($0)
                }
            }
        
        // 컬렉션뷰 바인딩
        Observable
            .combineLatest(spring, summer, autumn, winter)
            .subscribe(
                onNext: { [homeView] in
                homeView.setSnapshot(with: [$0, $1, $2, $3])
            },
                onError: { [weak self] error in
                    self?.showAlert(title: "Network Error", message: "데이터를 가져올 수 없습니다.\nError: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func setNavigationController() {
        self.title = "Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.preferredSearchBarPlacement = .stacked
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: true)
    }
}
