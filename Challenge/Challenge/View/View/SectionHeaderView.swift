//
//  SectionHeaderView.swift
//  Challenge
//
//  Created by Hanjuheon on 3/16/26.
//

import UIKit
import Then
import SnapKit

// 섹션 헤더
class SectionHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    static let id = "SectionHeader"
        
    //MARK: - Components
    let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .black
        $0.textAlignment = .natural
        $0.text = "타이틀"
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Update UI
    func setTtitle(title: String) {
        titleLabel.text = title
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
}

