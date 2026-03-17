//
//  SearchViewController.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
