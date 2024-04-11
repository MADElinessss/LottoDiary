//
//  CustomNavigationBar.swift
//  LottoDiary
//
//  Created by Madeline on 4/3/24.
//

import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    private let titleLabel = UILabel()
    private let logoImageView = UIImageView()

    init(title: String, logoImage: UIImage?) {
        super.init(frame: .zero)
        setupView(title: title, logoImage: logoImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String, logoImage: UIImage?) {
        addSubview(logoImageView)
        addSubview(titleLabel)
        
        logoImageView.image = logoImage
        logoImageView.contentMode = .scaleAspectFit
        titleLabel.text = title
        titleLabel.font = .pretendard(size: 16, weight: .bold)
        
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
    }
}
