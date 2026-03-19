//
//  ResultView.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/18/26.
//
import UIKit
import SnapKit
import RxSwift

final class ResultView: UIView {
    private let collectionView = ResultCollectionView()
    private lazy var dataSource = makeCollectionViewDiffableDataSource(collectionView)
    fileprivate var searchKeyword: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultView {
    private func setLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}


//MARK: CollectionView
extension ResultView {
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<ResultCollectionView.Section, ResultCollectionView.Item> {
        let headerRegistration = UICollectionView.SupplementaryRegistration<ResultHeaderView>(elementKind: "HeaderKind") { [weak self] supplementaryView, elementKind, indexPath in
            supplementaryView.configure(with: self?.searchKeyword ?? "")
        }
        
        let resultCellRegistration = UICollectionView.CellRegistration<ResultCardCell, ResultCollectionView.Item> { cell, indexPath, item in
            
            switch item {
            case .podcast(let podcast):
                cell.configure(with: podcast)
            case .tvShow(let tvShow):
                cell.configure(with: tvShow)
            }
        }
        
        let dataSource = UICollectionViewDiffableDataSource<ResultCollectionView.Section, ResultCollectionView.Item>(collectionView: collectionView) { collectionView, indexPath, item in
            
            collectionView.dequeueConfiguredReusableCell(using: resultCellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    func setSnapshot(with data: [ResultCollectionView.Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<ResultCollectionView.Section, ResultCollectionView.Item>()
        
        snapshot.appendSections([.result(searchKeyword)])
        snapshot.appendItems(data)
        
        dataSource.apply(snapshot)
    }
}

extension Reactive where Base: ResultView {
    var searchKeyword: Binder<String> {
        Binder(base) { view, keyword in
            view.searchKeyword = keyword
        }
    }
}
