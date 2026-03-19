//
//  ViewController.swift
//  Challenge
//
//  Created by Hanjuheon on 3/13/26.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

// 메인화면 컨트롤
class MainViewController: UIViewController {
    
    //MARK: - ViewModel
    var vm: MainViewModel
    
    private var disposeBag = DisposeBag()
    
    //MARK: - Components
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
    lazy var searchController = UISearchController(searchResultsController: SearchResultViewController(vm: SearchResultViewModel()))
    
    private var dataSource: UICollectionViewDiffableDataSource<SeasonKeyword, Music>!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Apple Music"
        // Do any additional setup after loading the view.
        configureUI()
        configureDataSource()
        bind()
        bindToSearch()
    }
    
    init() {
        self.vm = MainViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Bind
extension MainViewController {
    func bind() {
        let input = MainViewModel.Input(
            fetch: .just(()),
        )
        
        let output = vm.transform(input: input)
        
        output.update.subscribe(
            onNext: { [weak self] dic in
                guard let self else { return }
                self.applySnapshot(with: dic)
            }
        ).disposed(by: disposeBag)
    }
    
    func bindToSearch() {
        guard let searchVC = searchController.searchResultsController as? SearchResultViewController else { return }
        
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: searchVC.searchRelay)
            .disposed(by: disposeBag)
    }
}


//MARK: - CollectionView
extension MainViewController {
    private func applySnapshot(with dic: [SeasonKeyword: [Music]]) {
        var snapShot = NSDiffableDataSourceSnapshot<SeasonKeyword,Music>()
        snapShot.appendSections(SeasonKeyword.allCases)
        
        snapShot.appendItems(dic[.spring] ?? [Music](), toSection: .spring)
        snapShot.appendItems(dic[.summer] ?? [Music](), toSection: .summer)
        snapShot.appendItems(dic[.autumn] ?? [Music](), toSection: .autumn)
        snapShot.appendItems(dic[.winter] ?? [Music](), toSection: .winter)
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SeasonKeyword, Music>(
            collectionView: collectionView) { [weak self]
                collectionView, indexPath, item in
                
                guard let self else { return UICollectionViewCell() }
                
                let section = self.dataSource.snapshot().sectionIdentifiers
                let sectionType = section[indexPath.section]
                
                switch sectionType {
                case .spring, .autumn:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.id, for: indexPath) as? CardCell else {
                        return UICollectionViewCell() }
                    cell.updateUI(music: item)
                    
                    return cell
                case .summer, .winter:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.id, for: indexPath) as? ListCell else {
                        return UICollectionViewCell() }
                    cell.updateUI(music: item)

                    return cell
                }
            }
        dataSource.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self else { return nil }
            
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
        
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.id,
                for: indexPath) as? SectionHeaderView else {
                return nil
            }
            
            let sections = self.dataSource.snapshot().sectionIdentifiers
            let sectionType = sections[indexPath.section]
            
            header.setTtitle(title: sectionType.title)
            return header
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) ->
            NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers
            let sectionType = section[sectionIndex]
            
            switch sectionType {
            case .spring, .autumn:
                return self.cardSection()
            case .summer, .winter:
                return self.listSection()
            }
        }
    }
    
    private func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    private func cardSection()-> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .absolute(160),
                heightDimension: .absolute(190)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .absolute(160),
                heightDimension: .absolute(190)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 40, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader()]

        return section
    }
    
    private func listSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .fractionalWidth(1.0),
                      heightDimension: .fractionalHeight(1.0 / 3.0)))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:
                    .init(widthDimension: .fractionalWidth(1.0),
                          heightDimension: .absolute(240)),
            repeatingSubitem: item,
            count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 40)
        section.boundarySupplementaryItems = [sectionHeader()]

        return section
    }
}

//MARK: - ConfigureUI
extension MainViewController {
    private func configureUI() {
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked
        
        // 검색 활성화 시 뒤에 있던 기존 화면을 어둡게 가릴지 여부
        searchController.obscuresBackgroundDuringPresentation = true
        // 검색창 안에 회색 안내 문구 표시
        searchController.searchBar.placeholder = "검색"
        // SearchController의 표시 범위와 화면 전환을 관리하도록 설정
        definesPresentationContext = true
        
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.id)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
        
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}



@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: MainViewController())
}
