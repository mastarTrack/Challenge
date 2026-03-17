//
//  BestMusicCell.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/12/26.
//

import UIKit
import SnapKit
import Kingfisher

final class BestMusicCell: UICollectionViewCell {
    static let id = "BestMusicCell"
    
    let noteView = UIView()
    let albumImageView = UIImageView()
    let titleLabel = UILabel()
    let artistLabel = UILabel()
    
    // 음표 이미지 - 이미지 기본값으로 사용
    let noteImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(hierarchicalColor: .secondaryWhite)
        return UIImage(systemName: "music.note", withConfiguration: config)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        noteView.backgroundColor = randomBrightColor()
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        artistLabel.font = .systemFont(ofSize: 12, weight: .medium)
        artistLabel.textColor = .secondaryLabel
        
        albumImageView.contentMode = .center
        albumImageView.backgroundColor = .systemGray4
        albumImageView.layer.cornerRadius = 10
        albumImageView.clipsToBounds = true
        albumImageView.snp.makeConstraints {
            $0.width.height.equalTo(35)
        }
        
        albumImageView.kf.indicatorType = .activity // 이미지를 가져오는 동안 애니메이션 표출 옵션
    }
    
    private func setLayout() {
        let noteImageView = UIImageView(image: noteImage)
        noteImageView.contentMode = .scaleAspectFit
        
        let songBackgroundView = UIView()
        songBackgroundView.backgroundColor = .secondaryWhite
        
        let songlabelStack = UIStackView(vertical: [titleLabel, artistLabel])
        
        let songStack = UIStackView(horizontal: [albumImageView, songlabelStack])
        
        contentView.addSubview(noteView)
        contentView.addSubview(songBackgroundView)
        
        noteView.addSubview(noteImageView)
        songBackgroundView.addSubview(songStack)
        
        noteImageView.snp.makeConstraints {
            $0.width.height.equalToSuperview().multipliedBy(0.4)
            $0.center.equalToSuperview()
        }
        
        noteView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(songBackgroundView.snp.top)
        }
        
        songStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        songBackgroundView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
        }
    }
}

extension BestMusicCell {
    func configure(with music: Music) {
        titleLabel.text = music.title
        artistLabel.text = music.artist
        albumImageView.setImage(with: music.artworkUrl60 ?? "")
    }
}

extension BestMusicCell {    
    // 랜덤 컬러(밝은 색) 생성
    private func randomBrightColor() -> UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0.4...0.8)
        let brightness = CGFloat.random(in: 0.8...1.0)
        
        return UIColor(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: 1
        )
    }
}
