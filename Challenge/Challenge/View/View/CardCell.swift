//
//  CardCell.swift
//  Challenge
//
//  Created by Hanjuheon on 3/13/26.
//

import UIKit
import Then
import SnapKit
import Kingfisher

/// 카드형식 셀
class CardCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "CardCell"
        
    //MARK: - Components
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .natural
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "곡명"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray2
        $0.numberOfLines = 0
        $0.textAlignment = .natural
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "엘범 ・ 가수"
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
}

//MARK: - Update UI
extension CardCell {
    func updateUI(music: Music){
        titleLabel.text = music.trackName ?? "제목 없음"
        subTitleLabel.text = music.artistName ?? "아티스트 정보 없음"
        
        guard let urlString = music.artworkUrl100 else {
            return
        }
        
        imageView.kf.setImage(with: URL(string: urlString))
    }
}
//MARK: - Configure UI
extension CardCell {
    func configureUI() {
        let stackView = UIStackView().then{
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.spacing = 5
        }
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview().inset(10)
        }
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(16)
        }
    }
}


@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 250, height: 350)){
    CardCell()
}
