//
//  SearchResultViewController.swift
//  Challenge
//
//  Created by Hanjuheon on 3/17/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa


class SearchResultViewController: UIViewController {
    
    //MARK: - ViewModel
    var vm: SearchResultViewModel
    
    //MARK: - Properties
    var searchRelay = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    //MARK: - Components
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private var dataSource: UICollectionViewDiffableDataSource<MediaType, SearchItem>!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureDataSource()
        bind()
    }
    
    init(vm: SearchResultViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Binding
extension SearchResultViewController {
    func bind() {
        let input = SearchResultViewModel.Input(
            fatch: searchRelay.asObservable()
        )
        
        let output = vm.transForm(input: input)
        
        output.fatchItem
            .subscribe(
                onNext: { [weak self] item in
                    guard let self else { return }
                    self.applySnapShot(with: item.music, with: item.podcast)
                }
            ).disposed(by: disposeBag)
    }
}

//MARK: - CollectionView Setting
extension SearchResultViewController {
    
    func applySnapShot(with music: [Music], with podcast: [Podcast]) {
        var snapshot = NSDiffableDataSourceSnapshot<MediaType, SearchItem>()
        
        if !music.isEmpty {
            snapshot.appendSections([.music])
            let musicData = music.map { SearchItem.music($0) }
            snapshot.appendItems(musicData, toSection: .music)
        }
        
        if !podcast.isEmpty {
            snapshot.appendSections([.podcast])
            let podcastData = podcast.map { SearchItem.podcast($0) }
            snapshot.appendItems(podcastData, toSection: .podcast)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MediaType, SearchItem> (collectionView: collectionView) { [weak self]
            collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            switch item {
            case .podcast(let podcast):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchCardCell.id,
                    for: indexPath
                ) as? SearchCardCell else {
                    return UICollectionViewCell()
                }
                cell.updateUI(podcast: podcast)
                return cell
                
            case .music(let music):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ListCell.id,
                    for: indexPath
                ) as? ListCell else {
                    return UICollectionViewCell()
                }
                cell.updateUI(music: music)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return nil }
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.id,
                for: indexPath) as? SectionHeaderView else { return nil }
            
            let sections = self.dataSource.snapshot().sectionIdentifiers
            let sectionType = sections[indexPath.section]
            
            header.setTtitle(title: sectionType.title)
            return header
        }
    }
    

    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let sections = self.dataSource.snapshot().sectionIdentifiers
            let sectionType = sections[sectionIndex]
            
            switch sectionType {
            case .podcast:
                return self.CardSection()
            case .music:
                return self.listSection()
            }
        }
    }
    
    private func sectionHeader()-> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }
    
    func CardSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .fractionalWidth(1.0)),
            subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 0, bottom: 10, trailing: 40)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader()]
        
        return section
    }
    
    func listSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .fractionalWidth(1.0),
                      heightDimension: .fractionalHeight(1.0 / 5.0)))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:
                    .init(widthDimension: .fractionalWidth(1.0),
                          heightDimension: .absolute(400)),
            repeatingSubitem: item,
            count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 40)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [sectionHeader()]

        return section
    }
}

//MARK: - Configure UI
extension SearchResultViewController {
    func configureUI() {
        collectionView.register(SearchCardCell.self, forCellWithReuseIdentifier: SearchCardCell.id)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}


@available(iOS 17.0, *)
#Preview {
    SearchResultViewController(vm: SearchResultViewModel())
}

