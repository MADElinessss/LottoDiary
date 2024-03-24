//
//  MenuCollectionViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/10/24.
//

import SnapKit
import UIKit

final class MenuCollectionViewCell: UICollectionViewCell {
    
    let label = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
    }
    
    private func configureView() {
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-16)
            make.size.equalTo(40)
        }
        
        label.text = "번호 생성기"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        // imageView.image = UIImage(systemName: "mic.circle")?.withRenderingMode(.automatic)
        let originalImage = UIImage(named: "clover")
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        imageView.image = tintedImage
        imageView.tintColor = .point
        imageView.contentMode = .scaleAspectFit
        
    }
    
    func configure(with title: String, imageName: String) {
        label.text = title
        imageView.image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
