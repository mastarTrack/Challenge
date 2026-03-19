//
//  UIImageView.swift
//  Assignment_Challenge
//
//  Created by t2025-m0143 on 3/16/26.
//

import UIKit
import SnapKit
import Kingfisher

extension UIImageView {
    // 이미지 캐싱 활용
    func setImage(with urlString: String) {
        self.kf.indicatorType = .activity // 이미지 다운로드가 진행중일 경우 인디케이터 표시 옵션
        
        let retry = DelayRetryStrategy(maxRetryCount: 1, retryInterval: .seconds(3)) // 이미지 다운로드 실패 시 재실행 -- 3초 뒤 1번 재실행
        let placeholder = UIImage(systemName: "photo.trianglebadge.exclamationmark") // 이미지 로딩 실패 시 기본값
        let options: KingfisherOptionsInfo = [
            .retryStrategy(retry), // 재시도
            .transition(.fade(1.2)), // 1.2초 내에 이미지를 가져오지 못하면 애니메이션 표출
            .cacheOriginalImage // 원본 이미지 캐싱
        ]
        let url = URL(string: urlString)
        
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options
        )
    }
}
