//
//  ListMyNumberTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/20/24.
//

import UIKit

class ListMyNumberTableViewCell: UITableViewCell {
    
    var index: Int = 1
    let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        
    }
    
    private func configure() {
        
        contentView.addSubview(stackView)
        contentView.addSubview(titleLabel)
        
        backgroundColor = .white
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        titleLabel.text = "나의 번호(1)"
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = .black
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(contentView)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        for _ in 0..<6 {
            let button = UIButton()
            button.backgroundColor = .lightGray
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 15
            stackView.addArrangedSubview(button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
