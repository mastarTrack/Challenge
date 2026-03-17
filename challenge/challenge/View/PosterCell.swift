//
//  PosterCell.swift
//  challenge
//
//  Created by 손영빈 on 3/17/26.
//

import UIKit
import SnapKit
import Kingfisher

class PosterCell: UICollectionViewCell {
    
    static let id = "PosterCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PosterCell {
    private func setAttributes() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        artistNameLabel.font = .systemFont(ofSize: 14)
        artistNameLabel.textColor = .secondaryLabel
        artistNameLabel.numberOfLines = 0
    }
    
    private func setLayout() {
        [imageView, titleLabel, artistNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(artistNameLabel.snp.top).offset(-5)
        }
        artistNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}

extension PosterCell {
    func config(podcast: Podcast) {
        titleLabel.text = podcast.trackName
        artistNameLabel.text = podcast.artistName
        guard let url = podcast.artworkUrl600 else { return }
        imageView.kf.setImage(with: URL(string: url))
    }
}
