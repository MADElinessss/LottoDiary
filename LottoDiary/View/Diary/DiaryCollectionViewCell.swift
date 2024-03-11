//
//  DiaryCollectionViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/10/24.
//

import SnapKit
import UIKit

class DiaryCollectionViewCell: UICollectionViewCell {
    
    let tagLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with diary: Diary) {
        tagLabel.text = diary.tag
        contentLabel.text = diary.content
        dateLabel.text = FormatterManager.shared.formatDateToString(date: diary.date)
        if let imageName = diary.imageName, let image = UIImage(named: imageName) {
            imageView.image = image
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .white
        contentView.addSubview(tagLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageView)
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(200)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        tagLabel.text = "#캠핑카"
        tagLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        tagLabel.textColor = .red
        
        dateLabel.text = "TODAY"
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        contentLabel.text = "꿈자리가 사나웠따. 당첨되면 아파트 살거다."
        contentLabel.font = .systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 3
    }
}
