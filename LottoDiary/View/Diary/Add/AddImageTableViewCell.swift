//
//  AddImageTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import SnapKit
import UIKit

class AddImageTableViewCell: UITableViewCell {
    
    let customImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(customImageView)
        addSubview(titleLabel)
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(24)
        }
        
        customImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        customImageView.contentMode = .scaleAspectFit
    }
    
    func configure(with image: UIImage?, title: String) {
        customImageView.image = image
        titleLabel.text = title
    }
}
