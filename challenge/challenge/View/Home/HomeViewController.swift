//
//  ViewController.swift
//  challenge
//
//  Created by 손영빈 on 3/11/26.
//

import UIKit
import RxSwift
import RxCocoa

//TODO: 1. DiffableDataSource 생성, 2. Error 발생 시 print -> Alert로 변경

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, Music>!
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        configDataSource()
        bind()
        configSearchController()
    }
}

extension HomeViewController {
    private func bind() {
        // 파이프 설계
        let input = HomeViewModel.Input(initialized: Observable.just(()))
        // 파이프 연결(transform 내부 initialized -> Output 반환)
        let output = viewModel.transform(input: input)
        
        // Output 파이프 구독 (값 반환 시 setSnapshot 실행)
        output.musicInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] sections in
                self?.setSnapshot(sections: sections)
            }, onError: { [weak self] error in
                guard let error = error as? NetworkError else { return }
                self?.showErrorAlert(error: error)
            }).disposed(by: disposeBag)
    }
    
    private func setSnapshot(sections: [MusicSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, Music>()
        sections.forEach { // 순회하여 Section 생성, item 넣기
            snapshot.appendSections([$0.section])
            snapshot.appendItems($0.items, toSection: $0.section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController {
    private func setDelegate() {
        homeView.collectionView.delegate = self
        homeView.collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.id)
        homeView.collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)
        homeView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController {
    private func configDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: homeView.collectionView
        ) { collectionView, indexPath, music in
            guard let section = HomeSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .spring:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.id, for: indexPath) as? CardCell else { return UICollectionViewCell() }
                cell.config(music: music)
                return cell
            case .summer, .autumn, .winter:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.id, for: indexPath) as? ListCell else { return UICollectionViewCell() }
                cell.config(music: music)
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let section = HomeSection(rawValue: indexPath.section) else { return UICollectionReusableView() }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.id, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
            header.config(section: section)
            return header
        }
    }
}

extension HomeViewController {
    private func showErrorAlert(error: NetworkError) {
        
        let message: String
        
        switch error {
        case .requestError:
            message = "요청 에러"
        case .responseError:
            message = "서버 에러"
        case .decodingError:
            message = "디코딩 에러"
        }
        
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: true)
    }
}

extension HomeViewController {
    private func configSearchController() {
        let searchVC = SearchViewController()
        let searchController = UISearchController(searchResultsController: searchVC)
        searchController.searchBar.placeholder = "음악, 팟캐스트"
        navigationItem.searchController = searchController
        
        let searchText = searchController.searchBar.rx.text.orEmpty.asObservable()
        searchVC.bind(searchText: searchText)
        
    }
}
