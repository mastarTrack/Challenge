//
//  SearchResultCell.swift
//  Challenge
//
//  Created by Hanjuheon on 3/17/26.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class SearchCardCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "SearchCardCell"
    
    //MARK: - Components
    private let headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let subImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .black
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .natural
        $0.font = .boldSystemFont(ofSize: 24)
        $0.text = "타이틀 명"
    }
    
    private let genresLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .natural
        $0.font = .systemFont(ofSize: 16)
        $0.text = "장르 종류"
    }
    
    private let artistLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .natural
        $0.font = .boldSystemFont(ofSize: 18)
        $0.text = "아티스트"
    }
    
    private let trackLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .natural
        $0.font = .systemFont(ofSize: 16)
        $0.text = "에피소드 갯수 ⦁ 총 상영시간"
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - Update UI
extension SearchCardCell {
    func updateUI(podcast: Podcast) {
        titleLabel.text = podcast.collectionName
        genresLabel.text = podcast.genres?.joined(separator: " · ") ?? ""
        artistLabel.text = podcast.artistName
        trackLabel.text = " 총 \(podcast.trackCount ?? 0) 에피소드"
        
        guard let  mainImageUrl = podcast.artworkUrl600,
        let subImageUrl = podcast.artworkUrl60 else { return
        }
        
        headerImageView.kf.setImage(with: URL(string: mainImageUrl))
        subImageView.kf.setImage(with: URL(string: subImageUrl))
    }
}

//MARK: - Configure UI
extension SearchCardCell {
    func configureUI() {
        let view = UIView().then {
            $0.backgroundColor  = .clear
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor.systemGray6.cgColor
            $0.layer.borderWidth = 0.5
        }
        
        let subView = UIView().then {
            $0.backgroundColor  = UIColor(white: 0.9, alpha: 0.5)
            
        }
        
        let titleStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        let subStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.alignment = .fill
        }
        
        let infoStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        infoStackView.addArrangedSubview(artistLabel)
        infoStackView.addArrangedSubview(trackLabel)
        subStackView.addArrangedSubview(subImageView)
        subStackView.addArrangedSubview(infoStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(genresLabel)
        
        subView.addSubview(subStackView)
        view.addSubview(headerImageView)
        view.addSubview(titleStackView)
        view.addSubview(subView)
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        subView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        titleStackView.snp.makeConstraints {
            $0.bottom.equalTo(subView.snp.top).offset(-10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        subStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        subImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SearchCardCell()
}
