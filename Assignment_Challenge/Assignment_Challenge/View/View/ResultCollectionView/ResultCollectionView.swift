//
//  ResultCollection.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/18/26.
//

import UIKit

final class ResultCollectionView: UICollectionView {
    nonisolated
    enum Item: Hashable {
        case podcast(Podcast)
        case tvShow(TvShow)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .podcast(let podcast):
                hasher.combine(podcast)
            case .tvShow(let tvShow):
                hasher.combine(tvShow)
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = makeCompositionalLayout()
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultCollectionView {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.contentInsetsReference = .layoutMargins
        
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
            
            let itemWidth = environment.container.effectiveContentSize.width
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(itemWidth),
                    heightDimension: .absolute(itemWidth + 70)
                )
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(itemWidth),
                    heightDimension: .absolute(itemWidth + 70)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
//            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }, configuration: configuration)
    }
}
