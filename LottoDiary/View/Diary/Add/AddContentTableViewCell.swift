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
    let remainCountLabel = UILabel()
    let dateLabel = UILabel()
    let textView = UITextView()
    var diaryContent: String = ""
    var onTextChanged: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        //textView.becomeFirstResponder()
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
            make.bottom.equalTo(textView.snp.bottom).inset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.text = FormatterManager.shared.formatDateWithDayToString(date: Date())
        dateLabel.textColor = .black
        
        textView.text = textViewPlaceHolder
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.delegate = self
        textView.textColor = .black
        
        remainCountLabel.textColor = .black
        remainCountLabel.text = "0/500"
        remainCountLabel.font = .systemFont(ofSize: 14)
        remainCountLabel.textColor = .lightGray
        
    }
    
    private func updateCountLabel(characterCount: Int) {
        remainCountLabel.text = "\(characterCount)/500"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddContentTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
            updateCountLabel(characterCount: 0)
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
