//
//  CardCell.swift
//  challenge
//
//  Created by 손영빈 on 3/16/26.
//

import UIKit
import SnapKit
import Kingfisher

class CardCell: UICollectionViewCell {
    
    static let id = "CardCell"
    
    private let colorView = UIView()
    private let colors: [UIColor] = [.systemYellow, .systemPink, .systemOrange, .systemTeal, .systemIndigo]
    
    private let infoView = UIView()
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

extension CardCell {
    private func setAttributes() {
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        artistNameLabel.font = .systemFont(ofSize: 14)
        artistNameLabel.textColor = .secondaryLabel
    }
    
    private func setLayout() {
        [colorView, infoView].forEach { contentView.addSubview($0) }
        [imageView, titleLabel, artistNameLabel].forEach { infoView.addSubview($0) }
        
        colorView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.65)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(colorView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(infoView.snp.centerY).offset(-5)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalTo(infoView.snp.centerY).offset(5)
        }
        
    }
}

extension CardCell {
    func config(music: Music) {
        colorView.backgroundColor = randomColor()
        titleLabel.text = music.trackName
        artistNameLabel.text = music.artistName
        guard let url = music.artworkUrl60 else { return }
        imageView.kf.setImage(with: URL(string: url))
    }
}

extension CardCell {
    private func randomColor() -> UIColor {
        colors.randomElement() ?? .systemGray
    }
}
