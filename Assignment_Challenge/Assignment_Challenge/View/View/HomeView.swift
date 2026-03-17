//
//  HomeView.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//
import UIKit
import SnapKit

final class HomeView: UIView {
    private let collectionView = MusicCollectionView()
    private lazy var dataSource = makeCollectionViewDiffableDataSource(collectionView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    private func setLayout() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func convert(item: Item) -> Music {
        switch item {
        case let .spring(music):
            return music
        case let .summer(music):
            return music
        case let .autumn(music):
            return music
        case let .winter(music):
            return music
        }
    }
}

//MARK: CollectionView
extension HomeView {
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        let headerRegistration = UICollectionView.SupplementaryRegistration<MusicHeaderView>(elementKind: "HeaderKind") { supplementaryView, elementKind, indexPath in
            supplementaryView.configure(with: Section(rawValue: indexPath.section) ?? Section.spring)
        }
        
        let bestMusicCellRegistration = UICollectionView.CellRegistration<BestMusicCell, Item> { [weak self] cell, indexPath, item in
            guard let music = self?.convert(item: item) else { return }
            cell.configure(with: music)
        }
        
        let listMusicCellRegistration = UICollectionView.CellRegistration<MusicCell, Item> { [weak self] cell, indexPath, item in
            guard let music = self?.convert(item: item) else { return }
            cell.configure(with: music)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch Section(rawValue: indexPath.section) {
            case .spring:
                return collectionView.dequeueConfiguredReusableCell(using: bestMusicCellRegistration, for: indexPath, item: item)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: listMusicCellRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    
    func setSnapshot(with data: [[Item]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.spring, .summer, .autumn, .winter])
        
        snapshot.appendItems(data[Section.spring.rawValue], toSection: .spring)
        snapshot.appendItems(data[Section.summer.rawValue], toSection: .summer)
        snapshot.appendItems(data[Section.autumn.rawValue], toSection: .autumn)
        snapshot.appendItems(data[Section.winter.rawValue], toSection: .winter)
 
        dataSource.apply(snapshot)
    }
}
