//
//  StoreListTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/24/24.
//

import SnapKit
import UIKit

class StoreListTableViewCell: UITableViewCell {
    
    let indexLabel = UILabel()
    let titleLabel = UILabel()
    let addressLabel = UILabel()
    let phoneLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    func configure() {
        contentView.backgroundColor = .background
        contentView.addSubview(indexLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(phoneLabel)
        
        indexLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(indexLabel.snp.trailing).offset(16)
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.leading.equalTo(indexLabel.snp.trailing).offset(16)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).inset(-4)
            make.leading.equalTo(indexLabel.snp.trailing).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
