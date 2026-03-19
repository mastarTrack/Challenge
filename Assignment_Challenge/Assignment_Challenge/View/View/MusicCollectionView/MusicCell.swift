//
//  MusicListCell.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//

import UIKit
import SnapKit
import Kingfisher

final class MusicCell: UICollectionViewCell {
    static let id = "MusicListCell"
    
    let albumImageView = UIImageView()
    let titleLabel = UILabel() // 곡 제목
    let artistLabel = UILabel() // 가수
    let collectionLabel = UILabel() // 앨범명
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttributes()
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.kf.cancelDownloadTask()
        albumImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        albumImageView.contentMode = .center
        albumImageView.layer.cornerRadius = 10
        albumImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1

        artistLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        collectionLabel.font = .systemFont(ofSize: 12)
        collectionLabel.textColor = .secondaryLabel
    }
    
    private func setLayout() {
        let songLabelStack = UIStackView(vertical: [titleLabel, artistLabel, collectionLabel])
        
        contentView.addSubview(albumImageView)
        contentView.addSubview(songLabelStack)

        albumImageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }
        
        songLabelStack.snp.makeConstraints {
            $0.centerY.equalTo(albumImageView)
            $0.leading.equalTo(albumImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

extension MusicCell {
    func configure(with music: Music) {
        titleLabel.text = music.title
        artistLabel.text = music.artist
        collectionLabel.text = music.collection
        albumImageView.setImage(with: music.artworkUrl60 ?? "")
    }
}
