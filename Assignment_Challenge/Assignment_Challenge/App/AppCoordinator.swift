//
//  AppCoordinator.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//

/*
 화면 전환 및 의존성 주입을 담당하는 coordinator 객체입니다.
 */

import UIKit
import RxSwift

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    let networkService = NetworkService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController(viewModel: HomeViewModel(networkService: networkService))
        vc.coordinator = self
        
        setupSearchController(for: vc)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func setupSearchController(for homeVC: HomeViewController) {
        let resultVC = ResultViewController(
            viewModel: homeVC.viewModel,
            searchKeyword: homeVC.searchKeywordRelay.asObservable()
        )
        let searchController = UISearchController(searchResultsController: resultVC)
        
        searchController.obscuresBackgroundDuringPresentation = false // 검색바 클릭시 반투명하게 보이기
        searchController.searchBar.placeholder = "TV 프로그램, 팟캐스트"
        
        homeVC.navigationItem.searchController = searchController
        homeVC.navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 시 검색바 고정
    }
}
