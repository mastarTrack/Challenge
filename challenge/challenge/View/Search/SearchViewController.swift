//
//  SearchViewController.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchItem>!
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        configDataSource()
    }
}

extension SearchViewController {
    func bind(searchText: Observable<String>) {
        let input = SearchViewModel.Input(searchText: searchText)
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] podcast, music in
                self?.setSnapshot(podcast: podcast, music: music)
            }).disposed(by: disposeBag)
        
        output.searchResult
            .map { podcast, music in !(podcast.isEmpty && music.isEmpty) }
            .observe(on: MainScheduler.instance)
            .bind(to: searchView.collectionView.backgroundView!.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(error: error)
            }).disposed(by: disposeBag)
    }
    
    private func setSnapshot(podcast: [Podcast], music: [Music]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
        
        if !podcast.isEmpty || !music.isEmpty {
            snapshot.appendSections(SearchSection.allCases)
            snapshot.appendItems(podcast.map { .podcast($0) }, toSection: .podcast)
            snapshot.appendItems(music.map { .music($0) }, toSection: .music)
            
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchViewController {
    private func setDelegate() {
        searchView.collectionView.delegate = self
        searchView.collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.id)
        searchView.collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)
        searchView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
}

extension SearchViewController {
    private func configDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchView.collectionView) { collectionView, indexPath, identifier in
            switch identifier {
            case .podcast(let podcast):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.id, for: indexPath) as? PosterCell else { return UICollectionViewCell() }
                cell.config(podcast: podcast)
                return cell
            case .music(let music):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.id, for: indexPath) as? ListCell else { return UICollectionViewCell() }
                cell.config(music: music)
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let section = SearchSection(rawValue: indexPath.section) else { return UICollectionReusableView() }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.id, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
            header.config(section: section)
            return header
        }
    }
}

extension SearchViewController {
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
