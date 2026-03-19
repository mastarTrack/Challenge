//
//  ResultCardCell.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/18/26.
//

import UIKit
import SnapKit
import Kingfisher

final class ResultCardCell: UICollectionViewCell {
    static let id = "ResultCardCell"
    
    let titleLabel = UILabel()
    let secondaryLabel = UILabel()
    let artworkImageView = UIImageView()
    
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
        contentView.backgroundColor = UIColor.randomPastel
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        secondaryLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        secondaryLabel.textColor = .secondaryLabel
        
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.snp.makeConstraints {
            $0.height.equalTo(artworkImageView.snp.width)
        }
    }
    
    private func setLayout() {
        let labelStack = UIStackView(vertical: [secondaryLabel, titleLabel])
        
        contentView.addSubview(artworkImageView)
        contentView.addSubview(labelStack)
        
        artworkImageView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalTo(artworkImageView.snp.top).offset(-10)
        }
    }
}

extension ResultCardCell {
    func configure(with podcast: Podcast) {
        secondaryLabel.text = "PODCAST OF THE DAY"
        titleLabel.text = podcast.title
        artworkImageView.setImage(
            with: podcast.artworkUrl600 ?? podcast.artworkUrl100 ?? "")
    }
    
    func configure(with tvShow: TvShow) {
        secondaryLabel.text = "SPOTLIGHT"
        titleLabel.text = tvShow.title
        artworkImageView.setImage(
            with: tvShow.artworkUrl600 ?? tvShow.artworkUrl100 ?? "")
    }
}

