//
//  ViewController.swift
//  challenge
//
//  Created by 손영빈 on 3/11/26.
//

import UIKit
import RxSwift
import RxCocoa

//TODO: 1. DiffableDataSource 생성

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Music>!
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchAllMusicList()
        setDelegate()
        configDataSource()
        bind()
    }
}

extension HomeViewController {
    private func bind() {
        Observable.merge(
            viewModel.springList.asObservable(),
            viewModel.summerList.asObservable(),
            viewModel.autumnList.asObservable(),
            viewModel.winterList.asObservable()
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            self?.setSnapshot()
        }).disposed(by: disposeBag)
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Music>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.springList.value, toSection: .spring)
        snapshot.appendItems(viewModel.summerList.value, toSection: .summer)
        snapshot.appendItems(viewModel.autumnList.value, toSection: .autumn)
        snapshot.appendItems(viewModel.winterList.value, toSection: .winter)
        
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
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
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
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionReusableView() }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.id, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
            header.config(section: section)
            return header
        }
    }
}
