//
//  MyNumberTableViewCell.swift
//  LottoDiary
//
//  Created by Madeline on 3/14/24.
//

import SnapKit
import UIKit

class MyNumberTableViewCell: UITableViewCell {

    let numberSelectionView = NumberSelectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        
    }
    
    private func configure() {
        contentView.addSubview(numberSelectionView)
        numberSelectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
