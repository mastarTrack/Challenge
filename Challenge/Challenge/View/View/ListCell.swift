//
//  ListCell.swift
//  Challenge
//
//  Created by Hanjuheon on 3/13/26.
//

import UIKit
import Then
import SnapKit
import Kingfisher

/// 리스트형식 셀
class ListCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ListCell"
        
    //MARK: - Components
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .natural
        $0.lineBreakMode = .byTruncatingTail
        $0.text = "곡명"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
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
        fatalError("ListCell FatalError")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
}

//MARK: - Update UI
extension ListCell {
    func updateUI(music: Music){
        titleLabel.text = music.trackName ?? "제목 없음"
        subTitleLabel.text = music.artistName ?? "아티스트 정보 없음"
        
        guard let urlString = music.artworkUrl60 else {
            return
        }
        
        imageView.kf.setImage(with: URL(string: urlString))
    }
}


//MARK: - configure UI

extension ListCell {
    func configureUI() {
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 5
        }
        
        let titleStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 0
        }
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleStackView)
        
        contentView.addSubview(stackView)
        
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        titleStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
    }
}


@available(iOS 17.0, *)
#Preview{
    ListCell()
}
