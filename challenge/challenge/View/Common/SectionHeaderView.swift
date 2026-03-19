//
//  SectionHeaderView.swift
//  challenge
//
//  Created by 손영빈 on 3/16/26.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    
    static let id = "SectionHeaderView"
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionHeaderView {
    private func setAttributes() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        subTitleLabel.textColor = .secondaryLabel
    }
    
    private func setLayout() {
        [titleLabel, subTitleLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
}

extension SectionHeaderView {
    func config(section: SectionHeader) {
        titleLabel.text = section.title
        subTitleLabel.text = section.subTitle
    }
}
