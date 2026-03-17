//
//  HomeView.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/11/26.
//

import UIKit
import SnapKit

enum Section: Int {
    case spring
    case summer
    case autumn
    case winter
    
    var title: String {
        switch self {
        case .spring: "봄 Best"
        case .summer: "여름"
        case .autumn: "가을"
        case .winter: "겨울"
        }
    }
    
    var secondaryTitle: String {
        switch self {
        case .spring: "봄에 어울리는 음악 Best 5"
        case .summer: "여름에 어울리는 음악"
        case .autumn: "가을에 어울리는 음악"
        case .winter: "겨울에 어울리는 음악"
        }
    }
}

nonisolated
enum Item: Hashable {
    case spring(Music)
    case summer(Music)
    case autumn(Music)
    case winter(Music)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .spring(let music):
            hasher.combine("spring")
            hasher.combine(music)
        case .summer(let music):
            hasher.combine("summer")
            hasher.combine(music)
        case .autumn(let music):
            hasher.combine("autumn")
            hasher.combine(music)
        case .winter(let music):
            hasher.combine("winter")
            hasher.combine(music)
        }
    }
}

final class MusicCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = makeCompositionalLayout()
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicCollectionView {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        configuration.contentInsetsReference = .layoutMargins
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(54)
                ),
                elementKind: "HeaderKind",
                alignment: .top
            )
            
            switch Section(rawValue: sectionIndex) {
            case .spring:
                let section = self?.makeSpringSectionLayout(environment: environment)
                section?.boundarySupplementaryItems = [headerItem]
                
                return section
                
            default:
                let section = self?.makeListSectionLayout(environment: environment)
                section?.boundarySupplementaryItems = [headerItem]
                
                return section
            }
        }, configuration: configuration)
    }
    
    // 봄 섹션 레이아웃 생성
    private func makeSpringSectionLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.95),
                heightDimension: .fractionalWidth(0.6)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    // 곡 목록 섹션 레이아웃 생성
    private func makeListSectionLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(250)
            ),
            repeatingSubitem: item,
            count: 3
            )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}
