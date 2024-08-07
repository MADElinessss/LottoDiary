//
//  AddContentTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import SnapKit
import UIKit

final class AddContentTableViewCell: UITableViewCell {
    
    let textViewPlaceHolder = "오늘은 어떤 일이 있었나요?"
    
    var textView = UITextView()
    
    let remainCountLabel = UILabel()
    let dateLabel = UILabel()
    
    var diaryContent: String = ""
    var onTextChanged: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
        updateCountLabel(characterCount: textView.text.count)
    }
    
    private func configureView() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(textView)
        contentView.addSubview(remainCountLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(18)
        }
        
        textView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
        
        remainCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(textView.snp.bottom)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        dateLabel.font = .pretendard(size: 16, weight: .semibold)
        dateLabel.text = FormatterManager.shared.formatDateWithDayToString(date: Date())
        dateLabel.textColor = .black
        
        textView.delegate = self
        textView.attributedText = attributedPlaceholderText()
        
        remainCountLabel.text = "0/500"
        remainCountLabel.font = .systemFont(ofSize: 14)
        remainCountLabel.textColor = .lightGray
        
    }
    
    private func updateCountLabel(characterCount: Int) {
        if textView.textColor == .lightGray {
            remainCountLabel.text = "0/500"
        } else {
            remainCountLabel.text = "\(characterCount)/500"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddContentTableViewCell: UITextViewDelegate {
    
    private func attributedPlaceholderText() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.lightGray,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: textViewPlaceHolder, attributes: attributes)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
            remainCountLabel.text = "0/500"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 500 else { return false }
        updateCountLabel(characterCount: characterCount)
        
        return true
    }
}
