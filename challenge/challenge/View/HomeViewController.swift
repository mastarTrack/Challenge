//
//  ViewController.swift
//  challenge
//
//  Created by 손영빈 on 3/11/26.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchAllMusicList()
        setDelegate()
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
            self?.homeView.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func setDelegate() {
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        homeView.collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.id)
        homeView.collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.id)
        homeView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.id)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.id, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionReusableView() }
        header.config(section: section)
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .spring:
            return viewModel.springList.value.count
        case .summer:
            return viewModel.summerList.value.count
        case .autumn:
            return viewModel.autumnList.value.count
        case .winter:
            return viewModel.winterList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        let music: Music
        switch section {
        case .spring:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.id, for: indexPath) as? CardCell else { return UICollectionViewCell()}
            cell.config(music: viewModel.springList.value[indexPath.item])
            return cell
        case .summer, .autumn, .winter:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.id, for: indexPath) as? ListCell else { return UICollectionViewCell() }
            switch section {
            case .summer:
                music = viewModel.summerList.value[indexPath.item]
            case .autumn:
                music = viewModel.autumnList.value[indexPath.item]
            case .winter:
                music = viewModel.winterList.value[indexPath.item]
            default:
                return UICollectionViewCell()
            }
            cell.config(music: music)
            return cell
        }
    }
}

