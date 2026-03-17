//
//  ListCell.swift
//  challenge
//
//  Created by 손영빈 on 3/16/26.
//

import UIKit
import SnapKit
import Kingfisher

class ListCell: UICollectionViewCell {
    static let id = "ListCell"
    
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

extension ListCell {
    private func setAttributes() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.font = .systemFont(ofSize: 14)
        artistNameLabel.textColor = .secondaryLabel
    }
    
    private func setLayout() {
        [imageView, titleLabel, artistNameLabel].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(contentView.snp.centerY).offset(-5)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalTo(contentView.snp.centerY).offset(5)
        }
    }
}

extension ListCell {
    func config(music: Music) {
        titleLabel.text = music.trackName
        artistNameLabel.text = music.artistName
        guard let url = music.artworkUrl60 else { return }
        imageView.kf.setImage(with: URL(string: url))
    }
}
