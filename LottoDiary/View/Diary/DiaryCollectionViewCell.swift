//
//  DiaryCollectionViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/10/24.
//

import SnapKit
import UIKit

final class DiaryCollectionViewCell: UICollectionViewCell {
    
    let tagLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let imageView = UIImageView()
    let viewModel = DiaryViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        imageView.contentMode = .scaleAspectFit
        setupTagLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with diary: Diary) {
        
        contentLabel.text = diary.content
        contentLabel.font = .pretendard(size: 16, weight: .regular)
        
        let todayDateString = FormatterManager.shared.formatDateToString(date: Date())
        let diaryDateString = FormatterManager.shared.formatDateToString(date: diary.date)
        dateLabel.text = todayDateString == diaryDateString ? "TODAY" : diaryDateString
        dateLabel.font = .pretendard(size: 12, weight: .light)
        
        if let imageName = diary.imageName {
            loadImageFromDocumentDirectory(fileName: imageName)
        } else {
            imageView.isHidden = true
        }
        
        if let tag = diary.tag, let colorName = diary.colorString {
            tagLabel.text = "#\(tag)"
            tagLabel.font = .pretendard(size: 18, weight: .semibold)
            tagLabel.textColor = UIColor(named: colorName) ?? .black
        }
    }
    
    private func loadImageFromDocumentDirectory(fileName: String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory?.appendingPathComponent(fileName)
        if let imageData = try? Data(contentsOf: fileURL!), let image = UIImage(data: imageData) {
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
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(18)
            make.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(200)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(24)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(32)
        }
        
        tagLabel.text = ""
        tagLabel.font = .pretendard(size: 18, weight: .semibold)
        tagLabel.textColor = .red
        
        dateLabel.text = "TODAY"
        dateLabel.textColor = .gray
        dateLabel.font = .pretendard(size: 12, weight: .light)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributedString = NSMutableAttributedString(string: "꿈자리가 사나웠다. 당첨되면 아파트 살거다.")
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        contentLabel.attributedText = attributedString
        contentLabel.font = .pretendard(size: 16, weight: .regular)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
    }
    
    private func setupTagLabel() {
        
        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tagLabel.font = UIFont.pretendard(size: 14, weight: .medium)
    }
}
