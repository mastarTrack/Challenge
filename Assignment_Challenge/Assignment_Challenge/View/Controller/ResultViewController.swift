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
    private let resultView = ResultView()
    
    private let searchKeyword: Observable<String>
    
    override func loadView() {
        view = resultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
        
        let podcast = output.podcast
            .map { podcasts in
                podcasts.map {
                    ResultCollectionView.Item.podcast($0)
                }
            }
            .share()
        
        let tvShow = output.tvShow
            .map { tvShows in
                tvShows.map {
                    ResultCollectionView.Item.tvShow($0)
                }
            }
            .share()
        
        // 컬렉션뷰 바인딩
        Observable
            .combineLatest(podcast, tvShow)
            .subscribe(
                onNext: { [resultView] podcast, tvShow in
                    let result = (podcast + tvShow).shuffled() // 랜덤 배열 생성
                    resultView.setSnapshot(with: result)
                },
                onError: { [weak self] error in
                    self?.showAlert(title: "Network Error", message: "데이터를 가져올 수 없습니다.\n\(error.localizedDescription)")
                })
            .disposed(by: disposeBag)
    }

}

extension ResultViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: true)
    }
}
