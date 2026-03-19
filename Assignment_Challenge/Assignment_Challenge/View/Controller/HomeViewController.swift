//
//  ViewController.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/11/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AVFoundation

class HomeViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    let viewModel: HomeViewModel
    
    private let disposeBag = DisposeBag()
    private let homeView = HomeView()
    
    let searchKeywordRelay = BehaviorRelay<String>(value: "")
    private var musicPlayer: AVPlayer?
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        bind()
    }
    
    //MARK: init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: bind
    private func bind() {
        // ResultVC와의 바인딩을 위한 searchBar 텍스트
        if let searchBar = navigationItem.searchController?.searchBar {
            searchBar.rx.text.orEmpty
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .bind(to: searchKeywordRelay)
                .disposed(by: disposeBag)
        }
        
        // 카드 셀 선택 시 해당 셀의 indexPath
        let cellSelected = homeView.collectionView.rx.itemSelected
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .share() hot observable이라 없어도됨
        
        // 선택된 카드 셀의 Item - Input과 바인딩
        let playMusic = cellSelected
            .map { [weak self] indexPath in
                self?.homeView.fetchItem(of: indexPath)
            }
        
        let input = HomeViewModel.Input(
            fetchData: .just(()),
            searchText: .empty(),
            playMusic: playMusic
        )
        
        let output = viewModel.transform(input)
        
        // 음악 데이터
        let spring = output.spring
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.spring($0)
                }
            }
        
        let summer = output.summer
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.summer($0)
                }
            }
        
        let autumn = output.autumn
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.autumn($0)
                }
            }
        
        let winter = output.winter
            .map { musics in
                musics.map {
                    MusicCollectionView.Item.winter($0)
                }
            }
        
        // 컬렉션뷰 바인딩
        Observable
            .combineLatest(spring, summer, autumn, winter)
            .subscribe(
                onNext: { [homeView] in
                homeView.setSnapshot(with: [$0, $1, $2, $3])
            },
                onError: { [weak self] error in
                    self?.showAlert(title: "Network Error", message: "데이터를 가져올 수 없습니다.\nError: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        // 미리듣기
        output.musicPreviewTarget
            .subscribe(
                onNext: { [weak self] target in
                    switch target {
                    case .success((let isNew, let music)):
                        self?.playPreview(of: music, isNew: isNew)
                    case .failure(let error):
                        self?.showAlert(title: "Error", message: "대상 파일을 찾지 못했습니다.")
                    }
                })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func setNavigationController() {
        self.title = "Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.preferredSearchBarPlacement = .stacked
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension HomeViewController {
    private func playPreview(of music: Music, isNew: Bool) {
        if isNew { // 새로운 곡이 선택되었을 경우
            guard let previewUrl = music.previewUrl, let url = URL(string: previewUrl) else { self.showAlert(title: "재생 오류", message: "미리듣기를 제공하지 않는 곡입니다."); return }
            let item = AVPlayerItem(url: url)
            
            musicPlayer = AVPlayer(playerItem: item)
            musicPlayer?.play()
        } else { // 기존 재생중인 곡이 선택되었을 경우
            if musicPlayer?.timeControlStatus == .playing { // 재생 중일 경우
                musicPlayer?.pause() // 정지
            } else { // 정지 중일 경우
                musicPlayer?.seek(to: .zero) // 음원 처음 부분으로 돌아감
                musicPlayer?.play() // 재생
            }
        }
        
        musicPlayer?.actionAtItemEnd = .pause // 음원 종료시 정지 상태로 변경
    }
}
