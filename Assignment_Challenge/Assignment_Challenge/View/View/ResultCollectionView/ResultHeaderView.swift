//
//  ResultHeaderView.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/19/26.
//

import UIKit
import SnapKit

final class ResultHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultHeaderView {
    func configure(with text: String) {
        titleLabel.text = text
    }
}
