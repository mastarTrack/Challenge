//
//  MusicHeaderView.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/13/26.
//
import UIKit
import SnapKit

final class MusicHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(secondaryLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        secondaryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicHeaderView {
    func configure(with section: MusicCollectionView.Section) {
        titleLabel.text = section.title
        secondaryLabel.text = section.secondaryTitle
    }
}
