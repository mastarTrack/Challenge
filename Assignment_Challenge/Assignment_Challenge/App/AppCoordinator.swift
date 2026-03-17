//
//  AppCoordinator.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//

import UIKit

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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController(viewModel: MusicViewModel())
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
